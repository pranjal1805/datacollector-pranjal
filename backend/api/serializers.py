from rest_framework import serializers
from .models import *

datetime_format_str = '%Y-%m-%d %H:%M:%S.%f'

class InputSerializer(serializers.Serializer):
	sensor_id = serializers.IntegerField()
	count = serializers.IntegerField()
	data = serializers.ListField(
		child=serializers.JSONField()
	)

class FileSerializer(serializers.ModelSerializer):
	class Meta():
		model = File
		fields = '__all__'

class AnalyticsSerializer(serializers.ModelSerializer):
	class Meta():
		model = Analytics
		fields = '__all__'

class Sensor_ReadingSerializer(serializers.ModelSerializer):
	class Meta():
		model = Sensor_Reading
		fields = '__all__'
		
#for upload as file method
class Sensor_Reading_FileSerializer(serializers.ModelSerializer):
	class Meta():
		model = Sensor_Reading_File
		fields = ['sensor_type','time','data_file']

class Analytics_FileSerializer(serializers.ModelSerializer):
	class Meta():
		model = Analytics_File
		fields = '__all__'
		
class Sensor_Reading_Query_FileSerializer(serializers.Serializer):
	start = serializers.DateTimeField(format=datetime_format_str, input_formats=[datetime_format_str])
	end = serializers.DateTimeField(format=datetime_format_str, input_formats=[datetime_format_str])
	sensors = serializers.ListField(child=serializers.IntegerField() )
	users = serializers.ListField(child=serializers.IntegerField() )

class Sensor_Reading_ZipSerializer(serializers.Serializer):
	zip_file =serializers.FileField()
	sensor_id = serializers.IntegerField()
	# timestamps = serializers.ListField(
	# 	child=serializers.IntegerField(allow_null=False)
	# )

class QuestionnaireSerializer(serializers.ModelSerializer):
	class Meta():
		model = Questionnaire
		fields = '__all__'

class ResponsesSerializer(serializers.ModelSerializer):
	class Meta():
		model = Responses
		fields = ['__all__']

class AnnoationSerializer(serializers.Serializer):
	user = serializers.IntegerField()
	annotations = serializers.ListField(child=serializers.FileField( use_url=False ) )

class Ml_ModelSerializer(serializers.Serializer):
	class Meta():
		model = Ml_Model
		fields = ['__all__']