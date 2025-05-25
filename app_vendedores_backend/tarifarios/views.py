from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from tarifarios.models import Tarifario, Plan
from tarifarios.serializers import PlanSerializer
from tarifarios.serializers import TarifarioSerializer

# metodos para listar, crear, editar y eliminar planes
class PlanListView(APIView):
    def get(self, request):
        planes = Plan.objects.all()
        serializer = PlanSerializer(planes, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

class CreatePlanView(APIView):
    def post(self, request):
        serializer = PlanSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class EditPlanView(APIView):
    def post(self, request):
        try:
            plan = Plan.objects.get(id=request.data.get("id"))
            plan.nombre = request.data.get("nombre")
            plan.save()
            return Response({"message": "Plan actualizado correctamente"}, status=status.HTTP_200_OK)
        except Plan.DoesNotExist:
            return Response({"message": "El plan no existe"}, status=status.HTTP_400_BAD_REQUEST)

class DeletePlanView(APIView):
    def post(self, request):
        try:
            plan = Plan.objects.get(id=request.data.get("id"))
            plan.delete()
            return Response({"message": "Plan eliminado correctamente"}, status=status.HTTP_200_OK)
        except Plan.DoesNotExist:
            return Response({"message": "El plan no existe"}, status=status.HTTP_400_BAD_REQUEST)
        
# metodos para listar, crear, editar y eliminar tarifarios
class TarifarioListView(APIView):
    def get(self, request):
        tarifarios = Tarifario.objects.all()
        serializer = TarifarioSerializer(tarifarios, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
      
class CreateTarifarioView(APIView):
    def post(self, request):
        try:
            plan = Plan.objects.get(nombre=request.data.get("plan_nombre"))

            tarifario = Tarifario.objects.create(
                plan=plan,
                duracion=request.data.get("duracion", "Indefinido"),
                costo_total_minimo=request.data.get("costo_total_minimo"),
                costo_total_maximo=request.data.get("costo_total_maximo"),
                costo_mensual_minimo=request.data.get("costo_mensual_minimo"),
                costo_mensual_maximo=request.data.get("costo_mensual_maximo"),
                notas=request.data.get("notas", ""),
            )
            serializer = TarifarioSerializer(tarifario)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        except Plan.DoesNotExist:
            return Response({"message": "El plan especificado no existe"}, status=status.HTTP_400_BAD_REQUEST)

class EditTarifarioView(APIView):
    def post(self, request):
        try:
            tarifario = Tarifario.objects.get(id=request.data.get("id"))

            nuevo_plan_nombre = request.data.get("plan_nombre")
            if nuevo_plan_nombre:
                try:
                    nuevo_plan = Plan.objects.get(nombre=nuevo_plan_nombre)
                    tarifario.plan = nuevo_plan
                except Plan.DoesNotExist:
                    return Response({"message": "El nuevo plan no existe"}, status=status.HTTP_400_BAD_REQUEST)

            tarifario.duracion = request.data.get("duracion", tarifario.duracion)
            tarifario.costo_total_minimo = request.data.get("costo_total_minimo")
            tarifario.costo_total_maximo = request.data.get("costo_total_maximo")
            tarifario.costo_mensual_minimo = request.data.get("costo_mensual_minimo")
            tarifario.costo_mensual_maximo = request.data.get("costo_mensual_maximo")
            tarifario.notas = request.data.get("notas")
            tarifario.save()
            serializer = TarifarioSerializer(tarifario)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Tarifario.DoesNotExist:
            return Response({"message": "El tarifario no existe"}, status=status.HTTP_400_BAD_REQUEST)

class DeleteTarifarioView(APIView):
    def post(self, request):
        try:
            tarifario = Tarifario.objects.get(id=request.data.get("id"))
            tarifario.delete()
            return Response({"message": "Tarifario eliminado correctamente"}, status=status.HTTP_200_OK)
        except Tarifario.DoesNotExist:
            return Response({"message": "El tarifario no existe"}, status=status.HTTP_400_BAD_REQUEST)
