from django.urls import path
from .views import EmpresaRegistroView, CitasProgramadasView  # Importar desde la app correcta

urlpatterns = [
    path('empresa/registro/', EmpresaRegistroView.as_view(), name='empresa_registro'),
    path('citas/', CitasProgramadasView.as_view(), name='citas_programadas'),  # Nueva ruta
]
