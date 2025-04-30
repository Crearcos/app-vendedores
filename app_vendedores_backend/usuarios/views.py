# Create your views here.
import random
import string
from django.contrib.auth.models import User
from usuarios.models import UserProfile
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json
from django.contrib.auth import authenticate

@csrf_exempt
def login_view(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        email = data.get('email')
        password = data.get('password')

        # Buscar usuario por correo electrónico
        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            return JsonResponse({"status": -1, "message": "Usuario y/o contraseña incorrectos"})  # No existe el usuario

        # Validar contraseña usando Django
        user = authenticate(username=user.username, password=password)
        if user is None:
            return JsonResponse({"status": -1, "message": "Usuario y/o contraseña incorrectos"})  # Contraseña incorrecta

        # Obtener rol desde UserProfile
        try:
            profile = UserProfile.objects.get(user=user)
            role = profile.role
        except UserProfile.DoesNotExist:
            return JsonResponse({"status": -1, "message": "El usuario no tiene un rol asignado"})  # No tiene perfil

        # Determinar respuesta según el rol
        if role == "admin":
            return JsonResponse({"status": 0, "message": "Bienvenido Administrador"})
        elif role == "seller":
            return JsonResponse({"status": 1, "message": "Bienvenido Vendedor"})

        return JsonResponse({"status": -1, "message": "Rol desconocido"})  # Si el rol no es válido

    return JsonResponse({"error": "Método no permitido"}, status=405)

def generate_random_password(length=10):
    """Genera una contraseña aleatoria."""
    characters = string.ascii_letters + string.digits + string.punctuation
    return ''.join(random.choice(characters) for i in range(length))

@csrf_exempt
def register_user(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        email = data.get('email')
        role = data.get('role')

        # Verificar si el usuario ya existe
        if User.objects.filter(email=email).exists():
            return JsonResponse({"status": -1, "message": "El correo ya está registrado"})

        # Generar una contraseña aleatoria
        random_password = generate_random_password()
        print(f"Contraseña generada para {email}: {random_password}")  # Imprimir en la terminal

        # Crear usuario en auth_user
        user = User.objects.create_user(username=email, email=email, password=random_password)

        # Asignar rol en usuarios_userprofile
        UserProfile.objects.create(user=user, role=role)

        return JsonResponse({"status": 0, "message": "Usuario registrado exitosamente"})

    return JsonResponse({"error": "Método no permitido"}, status=405)