from urllib import request
from accounts.models import CustomUser
from .forms import CustomUserCreationForm
from .serializers import CustomUserSerializer,RegisterSerializer,AuthSerializer

from django.contrib.auth import login
from django.urls import reverse_lazy
from django.views.generic.edit import CreateView

from knox.models import AuthToken
from knox.views import LoginView 

from rest_framework import generics,permissions
from rest_framework.authtoken.serializers import AuthTokenSerializer
from rest_framework.response import Response

class SignUpView(CreateView):
    form_class = CustomUserCreationForm
    success_url = reverse_lazy('login')
    template_name = 'registration/signup.html'

class RegisterAPI(generics.GenericAPIView):
    serializer_class = RegisterSerializer

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data = request.data)
        serializer.is_valid(raise_exception = True) #TODO change to helpful return code
        user = serializer.save()
        return Response({
            "user": CustomUserSerializer(user, context=self.get_serializer_context()).data,
            "token": AuthToken.objects.create(user)[1] })

class LoginAPI(LoginView):
    serializer_class = AuthSerializer

    permission_classes = (permissions.AllowAny,)
    
    def post(self, request, format=None):
        serializer = AuthTokenSerializer(data=request.data)
        serializer.is_valid(raise_exception=True) #TODO change to helpful return code
        user = serializer.validated_data['user']
        login(request,user)
        return super(LoginAPI, self).post(request, format=None)

class Profile(generics.RetrieveAPIView):
    serializer_class = CustomUserSerializer
    permission_classes = (permissions.IsAuthenticated,)

    def get_object(self):
        return self.request.user