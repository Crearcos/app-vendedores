from django.urls import path
from .views import EmpresaRegistroView  # Importar desde la app correcta

urlpatterns = [
    path('empresa/registro/', EmpresaRegistroView.as_view(), name='empresa_registro'),
]