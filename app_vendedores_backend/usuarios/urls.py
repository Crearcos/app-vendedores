from django.urls import path
from .views import LoginView, RegisterUserView, ResetPasswordView  

urlpatterns = [
    path('login/', LoginView.as_view(), name='login'),
    path('register/', RegisterUserView.as_view(), name='register_user'),
    path('reset_password/', ResetPasswordView.as_view(), name='reset_password'),
]