import random
import string
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
        response_data = {"status": 0 if role == "administrador" else 1, "message": f"Bienvenido {role.capitalize()}"}
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

class ResetPasswordView(APIView):
    def post(self, request):
        data = request.data
        email = data.get('email')

        # Verificar si el usuario existe
        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            return Response({"status": -1, "message": "El correo no está registrado"}, status=status.HTTP_400_BAD_REQUEST)

        # Generar nueva contraseña aleatoria
        new_password = ''.join(random.choice(string.ascii_letters + string.digits + string.punctuation) for _ in range(10))
        user.set_password(new_password)
        user.save()

        # Enviar correo con la nueva contraseña
        send_mail(
            'Recuperación de contraseña - App Vendedores',
            f'Hola {user.username},\n\nTu nueva contraseña es:\n\n{new_password}\n\nPor favor, cambia tu contraseña después de iniciar sesión.',
            'soporte@crearcos.com',  # Remitente
            [email],  # Destinatario
            fail_silently=False,
        )

        return Response({"status": 0, "message": "Correo enviado con la nueva contraseña"}, status=status.HTTP_200_OK)
      
class UserListView(APIView):
    def get(self, request):
        users = User.objects.all()
        user_data = []

        for user in users:
            try:
                profile = UserProfile.objects.get(user=user)
                role = profile.role
            except UserProfile.DoesNotExist:
                role = "No asignado"

            user_data.append({
                "username": user.username,
                "email": user.email,
                "role": role
            })

        return Response(user_data, status=status.HTTP_200_OK)

class DeleteUserView(APIView):
    def post(self, request):
        data = request.data
        email = data.get('email')

        try:
            user = User.objects.get(email=email)
            if user.username == request.user.username:  # Evitar eliminarse a sí mismo
                return Response({"message": "No puedes eliminar tu propio usuario"}, status=status.HTTP_400_BAD_REQUEST)

            user.delete()
            return Response({"message": "Usuario eliminado correctamente"}, status=status.HTTP_200_OK)
        except User.DoesNotExist:
            return Response({"message": "El usuario no existe"}, status=status.HTTP_400_BAD_REQUEST)

class EditUserView(APIView):
    def post(self, request):
        data = request.data
        email = data.get('email')
        new_username = data.get('username')
        new_role = data.get('role')

        try:
            user = User.objects.get(email=email)
            user.username = new_username
            user.save()

            profile = UserProfile.objects.get(user=user)
            profile.role = new_role
            profile.save()

            return Response({"message": "Usuario actualizado correctamente"}, status=status.HTTP_200_OK)
        except User.DoesNotExist:
            return Response({"message": "El usuario no existe"}, status=status.HTTP_400_BAD_REQUEST)
        except UserProfile.DoesNotExist:
                return Response({"message": "El perfil de usuario no existe"}, status=status.HTTP_400_BAD_REQUEST)
