from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.http import FileResponse, HttpResponseNotFound
from django.conf import settings
import os

class SubirCatalogoView(APIView):
    def post(self, request):
        archivo = request.FILES.get('archivo')
        if not archivo or not archivo.name.endswith('.pdf'):
            return Response({"error": "Debes subir un archivo PDF"}, status=status.HTTP_400_BAD_REQUEST)

        os.makedirs(settings.CATALOGO_PATH, exist_ok=True)
        ruta = os.path.join(settings.CATALOGO_PATH, 'catalogo.pdf')

        with open(ruta, 'wb+') as destino:
            for chunk in archivo.chunks():
                destino.write(chunk)

        return Response({"message": "Catálogo subido exitosamente"}, status=status.HTTP_201_CREATED)

class ExisteCatalogoView(APIView):
    def get(self, request):
        ruta = os.path.join(settings.CATALOGO_PATH, 'catalogo.pdf')
        existe = os.path.isfile(ruta)
        return Response({"existe": existe}, status=status.HTTP_200_OK)

class DescargarCatalogoView(APIView):
    def get(self, request):
        ruta = os.path.join(settings.CATALOGO_PATH, 'catalogo.pdf')
        if os.path.isfile(ruta):
            return FileResponse(open(ruta, 'rb'), content_type='application/pdf', filename="catalogo.pdf")
        return HttpResponseNotFound("Catálogo no encontrado")

class EliminarCatalogoView(APIView):
    def post(self, request):
        ruta = os.path.join(settings.CATALOGO_PATH, 'catalogo.pdf')
        if os.path.isfile(ruta):
            os.remove(ruta)
            return Response({"message": "Catálogo eliminado correctamente"}, status=status.HTTP_200_OK)
        return Response({"error": "El archivo no existe"}, status=status.HTTP_404_NOT_FOUND)
