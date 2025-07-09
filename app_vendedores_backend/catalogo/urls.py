from django.urls import path
from .views import (
    SubirCatalogoView,
    ExisteCatalogoView,
    DescargarCatalogoView,
    EliminarCatalogoView
)

urlpatterns = [
    path("subir/", SubirCatalogoView.as_view(), name="subir_catalogo"),
    path("existe/", ExisteCatalogoView.as_view(), name="existe_catalogo"),
    path("descargar/", DescargarCatalogoView.as_view(), name="descargar_catalogo"),
    path("eliminar/", EliminarCatalogoView.as_view(), name="eliminar_catalogo"),
]
