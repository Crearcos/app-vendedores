# Configurar entorno de Django
import os
import django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'app_vendedores_backend.settings')
django.setup()

from django.contrib.auth.models import User
from usuarios.models import UserProfile
from tarifarios.models import Plan, Tarifario
from empresas.models import Empresa

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

empresa = Empresa.objects.create(nombre_empresa="TELSYNET", tipo_empresa="PYME", representante="CARLOS PONCE",cargo="GERENTE", modo_contacto="LLAMADA", telefono="0967613154")
empresa = Empresa.objects.create(nombre_empresa="FINCA DOMONTI", tipo_empresa="PYME", representante="DANIEL DOBRONSKI",cargo="FUNDADOR",email="fincadomonti@outlook.com", modo_contacto="WHATSAPP", telefono="0998113842")
empresa = Empresa.objects.create(nombre_empresa="FERNANDO BERNAL", tipo_empresa="PYME", representante="FERNANDO BERNAL",cargo="TITULAR", modo_contacto="WHATSAPP", telefono="0968919264")
empresa = Empresa.objects.create(nombre_empresa="COSMOSEG", tipo_empresa="PYME", representante="JOHN CABEZAS",cargo="SOCIO", modo_contacto="LLAMADA", telefono="0987592519")
empresa = Empresa.objects.create(nombre_empresa="ECHOARTE", tipo_empresa="PYME", representante="JORGE ROBY",cargo="DUEÑO", modo_contacto="LLAMADA", telefono="0961102517")
empresa = Empresa.objects.create(nombre_empresa="SOMBREROS", tipo_empresa="PYME", representante="MARIO PACHECO",cargo="DUEÑO", modo_contacto="LLAMADA", telefono="0979692701")
empresa = Empresa.objects.create(nombre_empresa="BIGEME S.A.", tipo_empresa="PYME", representante="SEBASTIAN FREIRE", modo_contacto="LLAMADA", telefono="0984292570")
empresa = Empresa.objects.create(nombre_empresa="EL OBRAJE", tipo_empresa="PYME", representante="G. COMERCIAL",cargo="WHATSAPP", modo_contacto="WHATSAPP", telefono="0999901087")
empresa = Empresa.objects.create(nombre_empresa="FABRIMASA", tipo_empresa="PYME", representante="WENDY MONTIEL",cargo="TGERENTE GENERAL", modo_contacto="LLAMADA", telefono="0991056175 / 0426029868")
empresa = Empresa.objects.create(nombre_empresa="ECUSCIENCE", tipo_empresa="PYME", representante="KARINA ORTEGA",cargo="REPRESENTANTE COMERCIAL", modo_contacto="WHATSAPP", telefono="00993404980")
empresa = Empresa.objects.create(nombre_empresa="SOFTWARE EVOLUTIVO", tipo_empresa="PYME", representante="OLIVIA",email="olivia@softwareevolutivo.net", modo_contacto="WHATSAPP", telefono="0979733071")
empresa = Empresa.objects.create(nombre_empresa="CARBONO NEUTRAL", tipo_empresa="PYME", representante="RAFAEL URQUIZO",cargo="JEFE DE MARKETING", email="rafaelurquizo@carbononeutral.com.ec", modo_contacto="WHATSAPP", telefono="0980015077")
empresa = Empresa.objects.create(nombre_empresa="FINCA DOMONTI", tipo_empresa="PYME", representante="DANIEL DOBRONSKI",cargo="FUNDADOR", email="fincadomonti@outlook.com",modo_contacto="WHATSAPP", telefono="0998113842")
empresa = Empresa.objects.create(nombre_empresa="LOGUN S.A.", tipo_empresa="PYME", representante="THALIA ALVARADO",cargo="TBUSINESS EXECUTIVE",email= "talvarado@grupoholco.com", modo_contacto="WHATSAPP", telefono="0968060501")
