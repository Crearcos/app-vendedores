from django.contrib.auth.models import User
from usuarios.models import UserProfile

# Crear usuario administrador con correo y contraseña
user = User.objects.create_user(username="admin1", email="admin@example.com", password="admin123")

# Asignar el rol de Administrador
UserProfile.objects.create(user=user, role="administrador")

# Crear usuario vendedor con correo y contraseña
user = User.objects.create_user(username="vendedor1", email="vendedor@example.com", password="vendedor123")

# Asignar el rol de Vendedor
UserProfile.objects.create(user=user, role="vendedor")