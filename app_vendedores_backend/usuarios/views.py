# Create your views here.
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
