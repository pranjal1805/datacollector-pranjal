from django.urls import path
from rest_framework.urlpatterns import format_suffix_patterns
from . import views
urlpatterns = [
    # sensor readings
	path('insert/', views.insert ,name='insert'),
	path('upload_readings/', views.SensorReadingFileView.as_view() ,name='upload_readings'),
	path('upload_zip/', views.SensorReadingUnzip.as_view() ,name='upload_zip'),
	path('query_readings_file/', views.ReadingQueryView.as_view() ,name='query_readings_file'),
	# files
	path('upload/', views.FileView.as_view() ,name='upload'),
	path('files/<int:pk>', views.FileMethods.as_view(), name='file_methods'),
	# analytics
	path('insert_analytics/', views.insert_analytics ,name='insert_analytics'),
	# questionnaires/notifications
	path('response/', views.ResponsesView.as_view(), name='upload_response'),
	path('response/<int:pk>', views.ResponsesMethods.as_view(), name='response_methods'),
	path('notif', views.QuestionnaireView.as_view(), name='upload_questionnaire'),	 	
	path('notif/<int:pk>', views.QuestionnaireMethods.as_view(), name='questionnaire_methods'),	 
	# annotations
	path('annotate/', views.UploadAnnotions.as_view(), name='upload_annotations')
]
urlpatterns = format_suffix_patterns(urlpatterns) # in order to accept URLS like "/entry-details/2.json" or "/entry-details/2.api" or "/entry-list.json"
