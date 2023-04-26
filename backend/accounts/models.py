from django.contrib.auth.models import AbstractUser
from django.db import models

#user model
def error_dict():
	return {'error':''}

class CustomUser(AbstractUser):
	# can add additional fields
	properties  = models.JSONField(blank=True, null=True, default=dict, help_text='A JSON field to specify misc properties')
	def __str__(self):
		return (self.username)

class Application(models.Model):
	name = models.CharField(max_length=100, blank=False,null=False)
	properties = models.JSONField(blank=True, null=True, default=dict, help_text='A JSON field to specify misc properties')
	def __str__(self):
		return (self.name)