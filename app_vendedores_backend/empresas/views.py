import random
import string
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
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
            'empresa_pyme', 'contacto', 'cargo', 'telefono',
            'ciudad', 'modo_contacto'
        ]
        
        missing_fields = [field for field in required_fields if field not in data]
        if missing_fields:
            return Response({
                "status": -1,
                "message": f"Faltan campos requeridos: {', '.join(missing_fields)}"
            }, status=status.HTTP_400_BAD_REQUEST)

        # Validar longitud del teléfono
        if len(data['telefono']) < 7:
            return Response({
                "status": -1,
                "message": "El teléfono debe tener al menos 7 dígitos"
            }, status=status.HTTP_400_BAD_REQUEST)

        # Crear la empresa
        serializer = EmpresaSerializer(data=data)
        if serializer.is_valid():
            empresa = serializer.save()

            # Enviar correo de confirmación
            # self._send_confirmation_email(empresa)

            return Response({
                "status": 0,
                "message": "Empresa registrada exitosamente",
                "data": {
                    "id": empresa.id,
                    "empresa": empresa.empresa_pyme,
                    "contacto": empresa.contacto
                }
            }, status=status.HTTP_201_CREATED)
        
        return Response({
            "status": -1,
            "message": "Error en los datos de la empresa",
            "errors": serializer.errors
        }, status=status.HTTP_400_BAD_REQUEST)

    # def _send_confirmation_email(self, empresa):
    #     send_mail(
    #         'Registro exitoso en App Vendedores',
    #         f'Hola {empresa.contacto},\n\n'
    #         f'Tu empresa {empresa.empresa_pyme} ha sido registrada exitosamente.\n\n'
    #         f'Datos de contacto:\n'
    #         f'Teléfono: {empresa.telefono}\n'
    #         f'Ciudad: {empresa.ciudad}\n\n'
    #         f'Modo de contacto preferido: {empresa.get_modo_contacto_display()}\n\n'
    #         f'Gracias por registrarte en nuestra plataforma.',
    #         settings.DEFAULT_FROM_EMAIL,
    #         [empresa.email],
    #         fail_silently=False,
    #     )