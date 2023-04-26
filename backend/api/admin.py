from pyexpat import model
from django.contrib import admin
from .models import *
# Register your models here.

@admin.register(Sensor)
class SensorAdmin(admin.ModelAdmin):
	readonly_fields = ('id',)
	list_display = ['type_of_sensor', 'device']

@admin.register(Device)
class DeviceAdmin(admin.ModelAdmin):
	readonly_fields = ('id',)
	list_display = ['name', 'user']

@admin.register(File)
class FileAdmin(admin.ModelAdmin):
	list_display = ['timestamp', 'file']

@admin.register(Analytics)
class AnalyticsAdmin(admin.ModelAdmin):
	readonly_fields = ('timestamp',)
	readonly_fields = ('id',)
	list_display = ['timestamp', 'sensor']

@admin.register(Sensor_Reading)
class Sensor_ReadingAdmin(admin.ModelAdmin):
	readonly_fields = ('time',)
	readonly_fields = ('id',)
	list_display = ['time', 'sensor']

@admin.register(Sensor_Reading_File)
class Sensor_ReadingFileAdmin(admin.ModelAdmin):
	readonly_fields = ('id',)
	list_display = ['user','sensor_type','time']

@admin.register(Schema)
class SchemaAdmin(admin.ModelAdmin):
	list_display = ['category','table']

@admin.register(Questionnaire)
class QuestionnaireAdmin(admin.ModelAdmin):
	readonly_fields = ('id',)
	list_display = ['app','title']

@admin.register(Responses)
class ResponsesAdmin(admin.ModelAdmin):
	readonly_fields = ('id',)
	list_display = ['questions','user']
