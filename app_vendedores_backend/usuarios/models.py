from django.contrib.auth.models import User
from django.db import models

class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)  # Relación con el usuario de Django
    role = models.CharField(max_length=20, choices=[('admin', 'Administrador'), ('seller', 'Vendedor')])

    def __str__(self):
        return f"{self.user.username} - {self.role}"