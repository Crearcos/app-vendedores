import random
import string
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.shortcuts import get_object_or_404
from .models import Empresa
from .serializers import EmpresaSerializer
from django.core.mail import send_mail
from django.conf import settings

class EmpresaRegistroView(APIView):
    def post(self, request):
        data = request.data
        print(data)

        # Validar campos requeridos
        required_fields = [
            'nombre_empresa', 'tipo_empresa', 'giro', 'representante',
            'cargo', 'telefono', 'ciudad', 'modo_contacto', 'necesidad_detectada', 'email'
        ]
        
        missing_fields = [field for field in required_fields if field not in data]
        if missing_fields:
            return Response({
                "status": -1,
                "message": f"Faltan campos requeridos: {', '.join(missing_fields)}"
            }, status=status.HTTP_400_BAD_REQUEST)

        # Validar formato del email correctamente
        if 'email' in data and not isinstance(data['email'], str):
            return Response({
                "status": -1,
                "message": "El formato del email es inválido"
            }, status=status.HTTP_400_BAD_REQUEST)

        # Validar longitud del teléfono
        if len(data.get('telefono', '')) < 7:
            return Response({
                "status": -1,
                "message": "El teléfono debe tener al menos 7 dígitos"
            }, status=status.HTTP_400_BAD_REQUEST)

        # Crear la empresa
        serializer = EmpresaSerializer(data=data)
        if serializer.is_valid():
            empresa = serializer.save()

            # Enviar correo de confirmación
            self._send_confirmation_email(empresa)

            return Response({
                "status": 0,
                "message": "Empresa registrada exitosamente",
                "data": {
                    "id": empresa.id,
                    "empresa": empresa.nombre_empresa,
                    "representante": empresa.representante,
                    "contacto_completo": empresa.contacto_completo,
                    "proxima_cita": empresa.proxima_cita
                }
            }, status=status.HTTP_201_CREATED)
        
        return Response({
            "status": -1,
            "message": "Error en los datos de la empresa",
            "errors": serializer.errors
        }, status=status.HTTP_400_BAD_REQUEST)

    def _send_confirmation_email(self, empresa):
        """Envía un correo de confirmación de registro"""
        subject = f'Confirmación de registro: {empresa.nombre_empresa}'
        message = f"""
        Gracias por registrar su empresa en nuestro sistema.
        
        Detalles del registro:
        - Empresa: {empresa.nombre_empresa}
        - Representante: {empresa.representante}
        - Cargo: {empresa.cargo}
        - Contacto: {empresa.telefono} | {empresa.email}
        
        Nos pondremos en contacto mediante: {empresa.get_modo_contacto_display()}
        
        Si necesita realizar algún cambio, no dude en contactarnos.
        """
        
        send_mail(
            subject,
            message,
            settings.DEFAULT_FROM_EMAIL,
            [empresa.email],
            fail_silently=False,
        )


### ✅ **Nueva vista para `/api/login/`**
Aquí está una implementación básica de autenticación:

```python
from django.contrib.auth import authenticate

class LoginView(APIView):
    def post(self, request):
        email = request.data.get('email')
        telefono = request.data.get('telefono')

        # Verificar que se envían email y teléfono
        if not email or not telefono:
            return Response({
                "status": -1,
                "message": "Se requiere email y teléfono para autenticarse"
            }, status=status.HTTP_400_BAD_REQUEST)

        # Buscar la empresa por email
        empresa = get_object_or_404(Empresa, email=email)

        # Verificar teléfono
        if empresa.telefono != telefono:
            return Response({
                "status": -1,
                "message": "Credenciales incorrectas"
            }, status=status.HTTP_401_UNAUTHORIZED)

        # Simular autenticación exitosa
        return Response({
            "status": 0,
            "message": "Login exitoso",
            "data": {
                "empresa": empresa.nombre_empresa,
                "representante": empresa.representante
            }
        }, status=status.HTTP_200_OK)
