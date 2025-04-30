from django.contrib.auth.models import User
from usuarios.models import UserProfile

# Crear usuario administrador con correo y contraseña
user = User.objects.create_user(username="admin", email="admin@example.com", password="admin123")

# Asignar el rol de "admin" (Administrador)
UserProfile.objects.create(user=user, role="admin")

# Crear usuario vendedor con correo y contraseña
user = User.objects.create_user(username="vendedor", email="vendedor@example.com", password="vendedor123")

# Asignar el rol de "seller" (Vendedor)
UserProfile.objects.create(user=user, role="seller")