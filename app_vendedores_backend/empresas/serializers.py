from rest_framework import serializers
from .models import Empresa

class EmpresaSerializer(serializers.ModelSerializer):
    modo_contacto = serializers.ChoiceField(choices=Empresa.MODO_CONTACTO_CHOICES, allow_blank=True, required=False)

    telefono = serializers.CharField(
        min_length=7, 
        allow_blank=True, 
        required=False
    )

    class Meta:
        model = Empresa
        fields = ['nombre_empresa', 'representante', 'cargo', 'telefono', 'ciudad', 'modo_contacto', 'email']
