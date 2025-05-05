from django.db import models
from django.contrib.auth.models import AbstractUser

class Usuario(AbstractUser):
    # Campos adicionales si los necesitas
    telefono = models.CharField(max_length=20, blank=True)
    direccion = models.TextField(blank=True)

    class Meta:
        verbose_name = 'Usuario'
        verbose_name_plural = 'Usuarios'