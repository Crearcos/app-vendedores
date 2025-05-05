import random
import string
import json
from django.contrib.auth.models import User
from usuarios.models import UserProfile
from django.core.mail import send_mail
from django.contrib.auth import authenticate
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from usuarios.serializers import UserSerializer, UserProfileSerializer

class LoginView(APIView):
    def post(self, request):
        data = request.data
        email = data.get('email')
        password = data.get('password')

        # Buscar usuario por correo electrónico
        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            return Response({"status": -1, "message": "Usuario y/o contraseña incorrectos"}, status=status.HTTP_400_BAD_REQUEST)

        # Validar contraseña
        user = authenticate(username=user.username, password=password)
        if user is None:
            return Response({"status": -1, "message": "Usuario y/o contraseña incorrectos"}, status=status.HTTP_400_BAD_REQUEST)

        # Obtener perfil
        try:
            profile = UserProfile.objects.get(user=user)
            role = profile.role
        except UserProfile.DoesNotExist:
            return Response({"status": -1, "message": "El usuario no tiene un rol asignado"}, status=status.HTTP_400_BAD_REQUEST)

        # Respuesta según el rol
        response_data = {"status": 0 if role == "admin" else 1, "message": f"Bienvenido {role.capitalize()}"}
        return Response(response_data, status=status.HTTP_200_OK)

class RegisterUserView(APIView):
    def post(self, request):
        data = request.data
        name = data.get('name')
        email = data.get('email')
        role = data.get('role')

        if User.objects.filter(email=email).exists():
            return Response({"status": -1, "message": "El correo ya está registrado"}, status=status.HTTP_400_BAD_REQUEST)

        # Generar contraseña aleatoria
        random_password = ''.join(random.choice(string.ascii_letters + string.digits + string.punctuation) for _ in range(10))

        # Crear usuario y perfil
        user = User.objects.create_user(username=name, email=email, password=random_password)
        UserProfile.objects.create(user=user, role=role)

        # Enviar correo
        send_mail(
            'Registro exitoso en la plataforma App Vendedores',
            f'Hola {name},\n\nTu cuenta ha sido creada.\nCorreo: {email}\nContraseña: {random_password}\n\nPor favor, cambia tu contraseña después de iniciar sesión.',
            'soporte@crearcos.com',
            [email],
            fail_silently=False,
        )

        return Response({"status": 0, "message": "Usuario registrado exitosamente"}, status=status.HTTP_201_CREATED)
