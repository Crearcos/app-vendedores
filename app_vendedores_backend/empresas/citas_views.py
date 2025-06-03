from rest_framework.views import APIView
from rest_framework.response import Response
from .models import Empresa
from rest_framework import status

class CitasProgramadasView(APIView):
    def get(self, request):
        empresas = Empresa.objects.filter(proxima_cita__isnull=False).order_by('proxima_cita')
        citas_data = [
            {
                "nombre_empresa": empresa.nombre_empresa,
                "representante": empresa.representante,
                "proxima_cita": empresa.proxima_cita.isoformat() if empresa.proxima_cita else None,
                "notas_cita": empresa.notas_cita,
            }
            for empresa in empresas
        ]
        return Response(citas_data, status=status.HTTP_200_OK)
