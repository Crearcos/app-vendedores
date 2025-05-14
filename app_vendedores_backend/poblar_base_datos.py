# Configurar entorno de Django
import os
import django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'app_vendedores_backend.settings')
django.setup()

from django.contrib.auth.models import User
from usuarios.models import UserProfile
from tarifarios.models import Plan, Tarifario

# Crear usuario administrador con correo y contraseña
user1 = User.objects.create_user(username="admin1", email="admin@example.com", password="admin123")
UserProfile.objects.create(user=user1, role="administrador")

# Crear usuario vendedor con correo y contraseña
user2 = User.objects.create_user(username="vendedor1", email="vendedor@example.com", password="vendedor123")
UserProfile.objects.create(user=user2, role="vendedor")

# Crear planes por defecto
plan1 = Plan.objects.create(nombre="Pyme")
plan2 = Plan.objects.create(nombre="Crecimiento")
plan3 = Plan.objects.create(nombre="Estratégico")

# Crear tarifarios por defecto
tarifario1 = Tarifario.objects.create(
    plan=plan1,
    duracion="6 meses",
    costo_total_minimo=1800,
    costo_total_maximo=2500,
    costo_mensual_minimo=300,
    costo_mensual_maximo=417,
    notas="Ideal para startups que buscan branding y presencia digital básica."
)

tarifario2 = Tarifario.objects.create(
    plan=plan1,
    duracion="1 año",
    costo_total_minimo=3200,
    costo_total_maximo=4000,
    costo_mensual_minimo=267,
    costo_mensual_maximo=333,
    notas="Descuento por compromiso anual; incluye soporte extendido."
)

tarifario3 = Tarifario.objects.create(
    plan=plan2,
    duracion="6 meses",
    costo_total_minimo=4000,
    costo_total_maximo=6000,
    costo_mensual_minimo=667,
    costo_mensual_maximo=1000,
    notas="Para negocios locales que necesitan expansión o fidelización."
)

tarifario4 = Tarifario.objects.create(
    plan=plan2,
    duracion="1 año",
    costo_total_minimo=7500,
    costo_total_maximo=9500,
    costo_mensual_minimo=625,
    costo_mensual_maximo=792,
    notas="Mejor valor por mes; incluye tecnología (app/web) y material ferial."
)

tarifario5 = Tarifario.objects.create(
    plan=plan3,
    duracion="1 año",
    costo_total_minimo=14000,
    costo_total_maximo=20000,
    costo_mensual_minimo=1167,
    costo_mensual_maximo=1667,
    notas="Diseñado para estrategias 360 y sistemas tecnológicos avanzados."
)