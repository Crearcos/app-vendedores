from rest_framework import serializers
from .models import Empresa

class EmpresaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Empresa
        fields = ['nombre', 'contacto', 'cargo', 'telefono', 'ciudad', 'modo_contacto']  # Solo los necesarios
        extra_kwargs = {
            'telefono': {'min_length': 7},
            'modo_contacto': {'choices': Empresa.MODO_CONTACTO_CHOICES}
        }