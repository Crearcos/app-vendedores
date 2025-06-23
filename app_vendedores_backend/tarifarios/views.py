from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from tarifarios.models import Tarifario, Plan, Paquete, Accion, Solucion
from tarifarios.serializers import PlanSerializer
from tarifarios.serializers import TarifarioSerializer
from tarifarios.serializers import PaqueteSerializer
from tarifarios.serializers import SolucionSerializer

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
        
# metodos para listar, crear, editar y eliminar paquetes
class PaqueteListView(APIView):
    def get(self, request):
        paquetes = Paquete.objects.all()
        serializer = PaqueteSerializer(paquetes, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

class CreatePaqueteView(APIView):
    def post(self, request):
        try:
            plan = Plan.objects.get(nombre=request.data.get("plan_nombre"))

            # Crear paquete
            paquete = Paquete.objects.create(
                plan=plan,
                ideal_para=request.data.get("ideal_para"),
                duracion=request.data.get("duracion"),
                soporte=request.data.get("soporte"),
                entregables=request.data.get("entregables"),
                kpis_sugeridos=request.data.get("kpis_sugeridos"),
                precio_minimo=request.data.get("precio_minimo"),
                precio_maximo=request.data.get("precio_maximo"),
            )

            # Agregar acciones al paquete con nombre y descripción
            acciones_data = request.data.get("acciones", [])
            for accion_data in acciones_data:
                accion, _ = Accion.objects.get_or_create(nombre=accion_data["nombre"], defaults={"descripcion": accion_data["descripcion"]})
                paquete.acciones.add(accion)

            serializer = PaqueteSerializer(paquete)
            return Response(serializer.data, status=status.HTTP_201_CREATED)

        except Plan.DoesNotExist:
            return Response({"message": "El plan especificado no existe"}, status=status.HTTP_400_BAD_REQUEST)

class EditPaqueteView(APIView):
    def post(self, request):
        try:
            paquete = Paquete.objects.get(id=request.data.get("id"))

            # **Actualizar datos del paquete**
            paquete.ideal_para = request.data.get("ideal_para", paquete.ideal_para)
            paquete.duracion = request.data.get("duracion", paquete.duracion)
            paquete.soporte = request.data.get("soporte", paquete.soporte)
            paquete.entregables = request.data.get("entregables", paquete.entregables)
            paquete.kpis_sugeridos = request.data.get("kpis_sugeridos", paquete.kpis_sugeridos)
            paquete.precio_minimo = request.data.get("precio_minimo", paquete.precio_minimo)
            paquete.precio_maximo = request.data.get("precio_maximo", paquete.precio_maximo)

            # **Actualizar acciones con nombre y descripción**
            paquete.acciones.clear()
            acciones_data = request.data.get("acciones", [])
            for accion_data in acciones_data:
                accion, _ = Accion.objects.get_or_create(nombre=accion_data["nombre"], defaults={"descripcion": accion_data["descripcion"]})
                paquete.acciones.add(accion)

            paquete.save()
            serializer = PaqueteSerializer(paquete)
            return Response(serializer.data, status=status.HTTP_200_OK)

        except Paquete.DoesNotExist:
            return Response({"message": "El paquete no existe"}, status=status.HTTP_400_BAD_REQUEST)

class DeletePaqueteView(APIView):
    def post(self, request):
        try:
            paquete = Paquete.objects.get(id=request.data.get("id"))
            paquete.delete()
            return Response({"message": "Paquete eliminado correctamente"}, status=status.HTTP_200_OK)
        except Paquete.DoesNotExist:
            return Response({"message": "El paquete no existe"}, status=status.HTTP_400_BAD_REQUEST)
        
# metodos para listar, crear, editar y eliminar soluciones
class ListarSolucionesView(APIView):
    def get(self, request):
        soluciones = Solucion.objects.all()
        serializer = SolucionSerializer(soluciones, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

class CrearSolucionView(APIView):
    def post(self, request):
        try:
            nombre = request.data.get("nombre")
            descripcion = request.data.get("descripcion")
            paquete_ids = request.data.get("paquetes", [])  # lista de IDs

            solucion = Solucion.objects.create(nombre=nombre, descripcion=descripcion)

            for paquete_id in paquete_ids:
                paquete = Paquete.objects.get(id=paquete_id)
                solucion.paquetes.add(paquete)

            serializer = SolucionSerializer(solucion)
            return Response(serializer.data, status=status.HTTP_201_CREATED)

        except Paquete.DoesNotExist:
            return Response({"message": "Alguno de los paquetes no existe."}, status=status.HTTP_400_BAD_REQUEST)
        except Exception as e:
            return Response({"message": str(e)}, status=status.HTTP_400_BAD_REQUEST)

class EditarSolucionView(APIView):
    def post(self, request):
        try:
            solucion = Solucion.objects.get(id=request.data.get("id"))
            solucion.nombre = request.data.get("nombre", solucion.nombre)
            solucion.descripcion = request.data.get("descripcion", solucion.descripcion)

            # Reemplazar todos los paquetes asociados
            paquete_ids = request.data.get("paquetes", [])
            solucion.paquetes.clear()
            for paquete_id in paquete_ids:
                paquete = Paquete.objects.get(id=paquete_id)
                solucion.paquetes.add(paquete)

            solucion.save()
            serializer = SolucionSerializer(solucion)
            return Response(serializer.data, status=status.HTTP_200_OK)

        except Solucion.DoesNotExist:
            return Response({"message": "La solución no existe"}, status=status.HTTP_400_BAD_REQUEST)
        except Paquete.DoesNotExist:
            return Response({"message": "Uno de los paquetes no existe"}, status=status.HTTP_400_BAD_REQUEST)
        except Exception as e:
            return Response({"message": str(e)}, status=status.HTTP_400_BAD_REQUEST)

class EliminarSolucionView(APIView):
    def post(self, request):
        try:
            solucion = Solucion.objects.get(id=request.data.get("id"))
            solucion.delete()
            return Response({"message": "Solución eliminada correctamente"}, status=status.HTTP_200_OK)
        except Solucion.DoesNotExist:
            return Response({"message": "La solución no existe"}, status=status.HTTP_400_BAD_REQUEST)
