from rest_framework import serializers
from tarifarios.models import Plan, Tarifario, Paquete, Accion

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

class AccionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Accion
        fields = ["id", "nombre", "descripcion"]

class PaqueteSerializer(serializers.ModelSerializer):
    plan_nombre = serializers.ReadOnlyField(source="plan.nombre")
    acciones = AccionSerializer(many=True)

    class Meta:
        model = Paquete
        fields = [
            "id", "plan", "plan_nombre", "ideal_para", "duracion",
            "soporte", "entregables", "kpis_sugeridos",
            "precio_minimo", "precio_maximo", "acciones"
        ]
