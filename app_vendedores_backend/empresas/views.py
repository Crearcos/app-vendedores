from rest_framework import viewsets
from .models import Empresa
from .serializers import EmpresaSerializer

class EmpresaViewSet(viewsets.ModelViewSet):
    """
    Vista para manejar operaciones CRUD de empresas
    """
    queryset = Empresa.objects.all()
    serializer_class = EmpresaSerializer