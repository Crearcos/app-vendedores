from django.urls import path
from .views import LoginView, RegisterUserView, ResetPasswordView, UserListView, DeleteUserView, EditUserView

urlpatterns = [
    path('login/', LoginView.as_view(), name='login'),
    path('register/', RegisterUserView.as_view(), name='register_user'),
    path('reset_password/', ResetPasswordView.as_view(), name='reset_password'),
    path('users/', UserListView.as_view(), name='user_list'),
    path('delete_user/', DeleteUserView.as_view(), name='delete_user'),
    path('edit_user/', EditUserView.as_view(), name='edit_user'),
]
