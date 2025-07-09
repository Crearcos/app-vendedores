from django.contrib import admin
from .models import Tarifario, Plan, Paquete, Accion, Solucion

admin.site.register(Tarifario)
admin.site.register(Plan)
admin.site.register(Paquete)
admin.site.register(Accion)
admin.site.register(Solucion)
