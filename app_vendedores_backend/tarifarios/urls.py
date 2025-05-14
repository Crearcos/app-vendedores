from django.urls import path
from .views import PlanListView, CreatePlanView, EditPlanView, DeletePlanView
from .views import TarifarioListView, CreateTarifarioView, EditTarifarioView, DeleteTarifarioView

urlpatterns = [
    path('listar_planes/', PlanListView.as_view(), name='listar_planes'),
    path('crear_plan/', CreatePlanView.as_view(), name='crear_plan'),
    path('editar_plan/', EditPlanView.as_view(), name='editar_plan'),
    path('eliminar_plan/', DeletePlanView.as_view(), name='eliminar_plan'),
    path('listar_tarifarios/', TarifarioListView.as_view(), name='listar_tarifarios'),
    path('crear_tarifario/', CreateTarifarioView.as_view(), name='crear_tarifario'),
    path('editar_tarifario/', EditTarifarioView.as_view(), name='editar_tarifario'),
    path('eliminar_tarifario/', DeleteTarifarioView.as_view(), name='eliminar_tarifario'),
]
