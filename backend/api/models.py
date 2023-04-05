from urllib import response
from django.db import models
from rest_framework.serializers import SerializerMetaclass
from accounts.models import CustomUser, Application
from timescale.db.models.fields import TimescaleDateTimeField
from timescale.db.models.managers import TimescaleManager


def error_dict():
	return {'error':''}
#function to give a directory structure to the model
def generate_filename(instance, filename):
	# path is already relative to MEDIA_ROOT
	return '/'.join(['sensor_readings',str(instance.time.year),str(instance.time.month),str(instance.time.day),str(instance.sensor_type.pk),filename])

class Schema(models.Model):
	# to track categories/tyepes and their schema of sensors, notifs, etc
	table = models.CharField(max_length=100, blank=False,null=False, help_text="table that uses this category belongs to, e.g. sensor", default="table_name")
	category = models.CharField(max_length=50, help_text="the category, e.g accelrometer\n. NULL if entire table has one schema", null=True) 
	schema = models.JSONField(blank=False, null=False, default=dict)
	def __str__(self):
		return ( (self.table) + '_' + (self.category) )

class Questionnaire(models.Model): #allow for Responses to not be tied to a particular application
	title =  models.CharField(max_length=100, blank=False,null=False, default="Question set")
	app = models.ForeignKey(Application, on_delete=models.RESTRICT, null=True, blank=True ) # one to many from appl to ques
	questions = models.JSONField(blank=False, null=False, default=dict)
	def __str__(self):
		return ( (self.title) + " for app: " + str(self.app) )
		
class Responses(models.Model): 
	user = models.ForeignKey(CustomUser, on_delete=models.RESTRICT, null=False, blank=False ) # one to many from user to response
	questions = models.ForeignKey(Questionnaire, on_delete=models.RESTRICT, null=False, blank=False ) # one to many from questionnaire to response
	answers = models.JSONField(blank=False, null=False, default=dict)
	def __str__(self):
		return ( str(self.user) + "'s response to " + str(self.questions))

class Device(models.Model):
	name = models.CharField(max_length=100, blank=False,null=False, default="device")
	user = models.ForeignKey(CustomUser, on_delete=models.RESTRICT, null=False, blank=False ) # one to many from user to device
	properties  = models.JSONField(blank=False, null=False, default=dict)
	def __str__(self):
		return ( str(self.user) + "_" + self.name + "_" + str(self.pk) )

class Sensor(models.Model):
	# each unique sensor
	type_of_sensor= models.ForeignKey(Schema, on_delete=models.RESTRICT, null=False, blank=False,help_text="Select schema. If suitable one doesn't exist, add one to Scehma table" ) # type, hence schema is selected here
	device = models.ForeignKey(Device, on_delete=models.RESTRICT, null=False, blank=False ) # one to many from device to sensor

	def __str__(self):
		return ( str(self.device) + "_" + str(self.type_of_sensor) + "_" + str(self.pk) )
	
class Sensor_Users(models.Model): 
	#mapping to store user:sensor:app
	sensor = models.ForeignKey(Sensor, on_delete=models.RESTRICT, null=False, blank=False )
	user = models.ForeignKey(CustomUser, on_delete=models.RESTRICT, null=False, blank=False )
	app = models.ForeignKey(Application, on_delete=models.RESTRICT, null=False, blank=False )

class Notification(models.Model):
	target_device = models.ForeignKey(Device, on_delete=models.RESTRICT, null=False, blank=False )
	contents = models.JSONField(blank=False, null=False, default=dict)
	type_of_notif= models.ForeignKey(Schema, on_delete=models.RESTRICT, null=False, blank=False ) # type, hence schema is selected here

class File(models.Model):
	# sensor Foreign Key Here.
	sensor = models.ForeignKey(Sensor, on_delete=models.RESTRICT, null=False, blank=False )
	timestamp = models.DateTimeField(blank=False,null=False)
	file_format = models.CharField(max_length=255, blank=True, null=True)
	file = models.FileField(blank=False, null=False, upload_to='files/%Y/%m/%d/')
	
class Analytics(models.Model):
	# sensor Foreign Key Here.
	sensor = models.ForeignKey(Sensor, on_delete=models.RESTRICT, null=False, blank=False )
	timestamp = models.DateTimeField(blank=False,null=False)
	data  = models.JSONField(blank=False, null=False, default=dict)

class Analytics_File(models.Model):
	# sensor Foreign Key Here.
	sensor = models.ForeignKey(Sensor, on_delete=models.RESTRICT, null=False, blank=False )
	timestamp = models.DateTimeField(blank=False,null=False)
	file = models.FileField(blank=False, null=False)

class Sensor_Reading(models.Model):
	# sensor Foreign Key Here.
	sensor = models.ForeignKey(Sensor, on_delete=models.DO_NOTHING, null=False, blank=False )
	time = TimescaleDateTimeField(blank=False,null=False,interval="1 day")
	data  = models.JSONField(blank=False, null=False, default=dict)

# Save reading as a text file
class Sensor_Reading_File(models.Model):
	# sensor Foreign Key Here.
	user = models.ForeignKey(CustomUser, on_delete=models.RESTRICT, null=False, blank=False )
	sensor_type= models.ForeignKey(Schema, on_delete=models.RESTRICT, null=False, blank=False,help_text="The type of sensor or annotation" ) # type, hence schema is selected here
	time = TimescaleDateTimeField(blank=False,null=False,interval="1 day")
	data_file = models.FileField(blank=False, null=False, upload_to=generate_filename)
	
	# def save(self, *args, **kwargs):
	# 		super(Sensor_Reading_File, self).save() # Call the "real" save() method.

class Ml_Model(models.Model):
	# sensor Foreign Key Here.
	user = models.ForeignKey(CustomUser, on_delete=models.RESTRICT, null=False, blank=False )
	time = TimescaleDateTimeField(blank=False,null=False,interval="1 day")
	properties = models.JSONField(blank=True, null=True)
	data_file = models.FileField(blank=False, null=False)
	