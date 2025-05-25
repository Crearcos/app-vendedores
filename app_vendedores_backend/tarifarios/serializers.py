from rest_framework import serializers
from tarifarios.models import Plan
from tarifarios.models import Tarifario

class PlanSerializer(serializers.ModelSerializer):
    class Meta:
        model = Plan
        fields = ['id', 'nombre']  # Incluye 'id' para referencia en el frontend

class TarifarioSerializer(serializers.ModelSerializer):
    plan_nombre = serializers.ReadOnlyField(source="plan.nombre") # Muestra el nombre del plan en vez de su ID

    class Meta:
        model = Tarifario
        fields = [
            "id", "plan", "plan_nombre", "duracion",
            "costo_total_minimo", "costo_total_maximo",
            "costo_mensual_minimo", "costo_mensual_maximo", "notas"
        ]
