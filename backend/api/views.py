# REST framework libs used
###
from rest_framework.response import Response
from rest_framework.parsers import MultiPartParser, FormParser, FileUploadParser
from rest_framework.views import APIView
from rest_framework.decorators import api_view
from rest_framework import status, generics, permissions #for CRUD
###

#Models and other local py imports
###
from .models import *
from .serializers import *
from .helper import nix_to_ts, TIMESTAMP_FORMAT
###

#Misc libs
###
import datetime
###

# libs for archiving and unzipping
###
from pathlib import Path 
from zipfile import ZIP_STORED, ZipFile
import os
from io import BytesIO
from django.http import FileResponse,HttpResponse
from django.core.files import File as File_helper
###

#BASE DIRECTORY NAME
BASE_DIR = Path(__file__).resolve().parent.parent

## Sensor Reading views
# [!Deprecated] bulk insert for sesnor stream data in JSON format
@api_view(['POST'])
def insert(request,format=None):
	start = datetime.datetime.now() # for logging insertion time.
	serializer = InputSerializer(data=request.data)
	# if valid, take the sensor ID
	# then insert each entry which is an item in a JSON array 
	if serializer.is_valid():
		sensor = Sensor.objects.get( pk = int(serializer.data['sensor_id']))
		data = (serializer.data['data'])
		to_save = []
		for line in data:
			# print(line['timestamp'])
			timestamp = datetime.datetime.strptime(line['timestamp'], '%Y-%m-%d %H:%M:%S.%f')
			a = Sensor_Reading(sensor=sensor,time=timestamp,data=line)
			to_save.append(a)
	Sensor_Reading.objects.bulk_create(to_save)
	delta = datetime.datetime.now() - start
	with open( str(BASE_DIR.joinpath('testing/delta.txt')) ,'a') as log:
		log.write(str(serializer.data['count'])+','+str(delta.total_seconds())+'\n')
		return Response(serializer.data)

# for inserting sesnor readings as single files ## current version
class SensorReadingFileView(APIView):
	parser_classes = (MultiPartParser, FormParser)
	permission_classes = (permissions.IsAuthenticated,)
	def post(self, request):
		start = datetime.datetime.now() # for logging insertion time.
		new_obj = request.data.copy()
		user = request.user
		# print(user)
		try:
			new_obj['time'] = nix_to_ts(int(request.data['time']))
		except:
			return Response("invalid format for timestamp", status=status.HTTP_400_BAD_REQUEST)
		# print(new_obj)
		file_serializer = Sensor_Reading_FileSerializer(data=new_obj)
		if file_serializer.is_valid():
			data_file = request.FILES['data_file']
			sensor_type_id = file_serializer.data['sensor_type']
			#TODO: catch exception if sensor id is invalid
			sensor_used = Schema.objects.get(pk=sensor_type_id)
			timestamp = datetime.datetime.strptime(str(new_obj['time']), '%Y-%m-%d %H:%M:%S.%f')
			to_save = Sensor_Reading_File(sensor_type=sensor_used, time=timestamp, data_file=data_file, user=user)
			to_save.save()
			delta = datetime.datetime.now() - start #for logging purposes
			return Response({
								'status':'data file saved successfuly',
								'user':str(user),
								'sensor_type':str(sensor_used)
							}, status=status.HTTP_201_CREATED)
		else:
			# TODO: Log errors here
			return Response(file_serializer.errors, status=status.HTTP_400_BAD_REQUEST)

# [!Deprecated] for extracting multiple sensor files from zip
class SensorReadingUnzip(APIView):
	parser_classes = (MultiPartParser, FormParser, FileUploadParser)
	def post(self, request):
		# start = datetime.datetime.now() # for logging insertion time.
		serializer = Sensor_Reading_ZipSerializer(data=request.data)
		# print(serializer)
		if serializer.is_valid():
			##IMP Check for integrity before extraction??
			zip_file = request.FILES['zip_file']
			# timestamps = serializer.data['timestamps'] # a list of timestamps?
			sensor_id = serializer.data['sensor_id']
			##IMP Check for valid sensor id
			sensor_used = Sensor.objects.get(pk=sensor_id)
			# print(timestamps[0])
			iter = 0
			with ZipFile(zip_file, 'r') as opened:
				files = opened.infolist()
				for readings_file in files:
					raw_data = BytesIO(opened.read(readings_file))
					fname = readings_file.filename
					file_obj = File_helper(raw_data, name=fname)
					ts = int(fname[fname.find('_')+1:fname.find('.')])
					print(ts)
					timestamp = datetime.datetime.strptime(nix_to_ts(ts), '%Y-%m-%d %H:%M:%S.%f')
					to_save = Sensor_Reading_File(sensor=sensor_used, time=timestamp, data_file=file_obj)
					to_save.save()
					iter+=1
					# print(readings_file.filename,timestamps[iter])

			return Response({"saved count":iter, "sensor":str(sensor_used), "sensor_id": sensor_id}, status=status.HTTP_201_CREATED)
		else:
			return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

# [!Deprecated] insert single sensor reading
@api_view(['POST'])
def insert_readings(request,format=None):
	serializer = Sensor_ReadingSerializer(data=request.data)
	if serializer.is_valid():
		serializer.save()
		print('saved')
	# print(serializer.data['device_id'])
	return Response(serializer.data)

# Querying: return a zip of all files in range
class ReadingQueryView(APIView):
	def post(self, request):
		new_obj = request.data.copy()
		# print(serializer)    
		try:
			new_obj['start'] = nix_to_ts(int(new_obj['start']))
			new_obj['end'] = nix_to_ts(int(new_obj['end']))
		except:
			return Response("invalid fromat for start or end timestamp", status=status.HTTP_400_BAD_REQUEST)
		query_serializer = Sensor_Reading_Query_FileSerializer(data=new_obj)
		if query_serializer.is_valid():
			# query the db to get a list of files
			start_datetime = (query_serializer.data['start'])
			end_datetime = (query_serializer.data['end'])
			files_list_qs = Sensor_Reading_File.objects.filter(time__range=(start_datetime,end_datetime))
			files_list_qs = files_list_qs.filter(user__pk__in=query_serializer.data['users'])
			#TODO: some logic to figure out annote ids needed. Addded to the filter below to simplify
			files_list_qs = files_list_qs.filter(sensor_type__pk__in=query_serializer.data['sensors'])
			# print(files_list_qs)
			# archive the file list 
			zip_subdir = 'query_result'
			zip_filename = "%s.zip" % zip_subdir
			# Open BytesIO to grab in-memory ZIP contents
			s = BytesIO()
			# The zip compressor
			zf = ZipFile(s, "w")
			for files in files_list_qs:
				# Calculate path for file in zip
				fdir, fname = os.path.split((files.data_file.path))
				zip_path = os.path.join(zip_subdir, fname)
				# Add file, at correct path
				zf.write(str(files.data_file.path), zip_path)
			# Add annoation files
			annote_files_qs = Sensor_Reading_File.objects.filter(time__range=(start_datetime,end_datetime))
			annote_files_qs = annote_files_qs.filter(user__pk__in=query_serializer.data['users'])
			annote_files_qs = annote_files_qs.filter(sensor_type__pk=3) # TODO: remove hardcoded annoatation type, accept a list			
			zip_subdir = "annotations"
			for files in annote_files_qs:
				# Calculate path for file in zip
				fdir, fname = os.path.split((files.data_file.path))
				zip_path = os.path.join(zip_subdir, fname)
				# Add file, at correct path
				zf.write(str(files.data_file.path), zip_path)
			# Must close zip for all contents to be written
			zf.close()
			 # Grab ZIP file from in-memory, make response with correct MIME-type
			resp = HttpResponse(s.getvalue(), content_type = "application/x-zip-compressed")
			# ..and correct content-disposition
			resp['Content-Disposition'] = 'attachment; filename=%s' % zip_filename
			print(resp)    
			return resp
			##credits: @dbr https://stackoverflow.com/questions/67454/serving-dynamically-generated-zip-archives-in-django
		else:
			return Response(query_serializer.errors,status=status.HTTP_400_BAD_REQUEST)

####################################################################

## Files
# insert a single file
class FileView(APIView):
	parser_classes = (MultiPartParser, FormParser)
	#create
	def post(self, request):
		file_serializer = FileSerializer(data=request.data)
		if file_serializer.is_valid():
			file_serializer.save()
			return Response(file_serializer.data, status=status.HTTP_201_CREATED)
		else:
			return Response(file_serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class FileMethods(generics.RetrieveUpdateDestroyAPIView):
	# HTTP methods included:
	# PUT- full update, PATCH- partial update, GET- retrive by id, DELETE- delete 
    queryset = File.objects.all()
    serializer_class = FileSerializer

####################################################################

## Notif/Questionnaire Views 
class QuestionnaireView(generics.CreateAPIView):
	# HTTP methods included:
	# POST - create questionnaire 
    queryset = Questionnaire.objects.all()
    serializer_class = QuestionnaireSerializer

class QuestionnaireMethods(generics.RetrieveUpdateDestroyAPIView):
	# HTTP methods included:
	# PUT- full update, PATCH- partial update, GET- retrive by id, DELETE- delete 
    queryset = Questionnaire.objects.all()
    serializer_class = QuestionnaireSerializer

class ResponsesView(generics.CreateAPIView):
	# HTTP methods included:
	# POST - create Response 
    queryset = Responses.objects.all()
    serializer_class = ResponsesSerializer

class ResponsesMethods(generics.RetrieveUpdateDestroyAPIView):
	# HTTP methods included:
	# PUT- full update, PATCH- partial update, GET- retrive by id, DELETE- delete 
    queryset = Responses.objects.all()
    serializer_class = ResponsesSerializer

####################################################################

## Analytics
# bulk insert for analytics data in JSON format
@api_view(['POST'])
def insert_analytics(request,format=None):
	serializer = InputSerializer(data=request.data)
	print('serializer')
	if serializer.is_valid():
		print('valid')
		print(serializer.data['sensor_id'])
		sensor = Sensor.objects.get( pk = int(serializer.data['sensor_id']))
		data = (serializer.data['data'])
		for line in data:
			# print(line['timestamp'])
			timestamp = datetime.datetime.strptime(line['timestamp'], '%Y-%m-%d %H:%M:%S.%f')
			a = Analytics(sensor=sensor,timestamp=timestamp,data=line['data'])
			a.save()
	return Response(serializer.data)

####################################################################

#Annotations TODO: UI 
class UploadAnnotions(APIView):
	def post(self, request, format=None):
		serializer = AnnoationSerializer(data=request.data)
		if serializer.is_valid():
			valid_count = 0
			for file in request.FILES.getlist('annotations'):
				fname = file.name
				user_id = serializer.data['user']
				# TODO: move to accept annotation type in field
				annotation_id = 3 #annoation
				#TODO add try-catch
				user = CustomUser.objects.get(pk=user_id)
				annotation = Schema.objects.get(pk=annotation_id)
				ts = int(fname[fname.find('_')+1:fname.find('.')])
				print(ts)
				timestamp = datetime.datetime.strptime(nix_to_ts(ts), '%Y-%m-%d %H:%M:%S.%f')
				to_save = Sensor_Reading_File(user=user, sensor_type=annotation, time=timestamp, data_file=file)
				to_save.save()
				valid_count += 1
			return Response("Saved {} annotation(s)".format(valid_count),status=status.HTTP_201_CREATED)
		else:
			return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

####################################################################

#Ml Models
class Ml_ModelMethods(generics.RetrieveUpdateDestroyAPIView):
	# HTTP methods included:
	# PUT- full update, PATCH- partial update, GET- retrive by id, DELETE- delete 
    queryset = Ml_Model.objects.all()
    serializer_class = Ml_ModelSerializer
