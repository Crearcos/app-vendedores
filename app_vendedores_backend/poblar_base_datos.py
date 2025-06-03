# Configurar entorno de Django
import time
import os
import django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'app_vendedores_backend.settings')
django.setup()

from django.contrib.auth.models import User
from usuarios.models import UserProfile
from tarifarios.models import Plan, Tarifario, Paquete, Accion
from empresas.models import Empresa

# Crear usuario administrador con correo y contraseña
user1 = User.objects.create_user(username="admin1", email="admin@example.com", password="admin123")
UserProfile.objects.create(user=user1, role="administrador")

# Crear usuario vendedor con correo y contraseña
user2 = User.objects.create_user(username="vendedor1", email="vendedor@example.com", password="vendedor123")
UserProfile.objects.create(user=user2, role="vendedor")
print("Usuarios creados exitosamente.")

# Crear planes por defecto
plan1 = Plan.objects.create(nombre="Pyme")
plan2 = Plan.objects.create(nombre="Crecimiento")
plan3 = Plan.objects.create(nombre="Estratégico")
print("Planes creados exitosamente.")

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
print("Tarifarios creados exitosamente.")

# Crear paquetes por defecto
paquete1 = Paquete.objects.create(
    plan=plan1,
    ideal_para="Negocios en etapa inicial que buscan construir una marca y ganar visibilidad.",
    duracion="6 meses",
    soporte="Reuniones mensuales para seguimiento de KPIs (engagement, alcance).",
    entregables="Manual de marca, videos, material POP, sitio web, informe de KPIs.",
    kpis_sugeridos="Crecimiento de seguidores (20%), Interacciones en redes (15%), Visitas web (500/mes).",
    precio_minimo=1500,
    precio_maximo=2000
)

accion1 = Accion.objects.create(nombre="BRANDING (Pyme 6 meses)",
                                 descripcion="Creación de identidad visual básica (logo, paleta de colores, tipografía).")
accion2 = Accion.objects.create(nombre="Comunicación audiovisual (Pyme 6 meses)",
                                 descripcion="2 videos cortos (30-60 seg) para redes sociales.")
accion3 = Accion.objects.create(nombre="BTL (Pyme 6 meses)",
                                 descripcion="Diseño de material pop (flyers, stickers) o activaciones locales.")
accion4 = Accion.objects.create(nombre="Digital (Pyme 6 meses)",
                                 descripcion="Desarrollo de sitio web básico (onepage, responsive) o perfil optimizado en redes.")
accion5 = Accion.objects.create(nombre="Capacitación (Pyme 6 meses)",
                                 descripcion="1 taller (2 horas) sobre gestión de marca personal o redes sociales.")
paquete1.acciones.add(accion1, accion2, accion3, accion4, accion5)

paquete2 = Paquete.objects.create(
    plan=plan1,
    ideal_para="Negocios en etapa inicial que buscan construir una marca y ganar visibilidad.",
    duracion="1 año",
    soporte="Reuniones mensuales para seguimiento de KPIs (engagement, alcance).",
    entregables="Manual de marca, videos, material POP, sitio web, informe de KPIs.",
    kpis_sugeridos="Crecimiento de seguidores (20%), Interacciones en redes (15%), Visitas web (500/mes).",
    precio_minimo=2800,
    precio_maximo=3500
)

accion1 = Accion.objects.create(nombre="BRANDING (Pyme 1 año)",
                                 descripcion="Creación de identidad visual básica (logo, paleta de colores, tipografía).")
accion2 = Accion.objects.create(nombre="Comunicación audiovisual (Pyme 1 año)",
                                 descripcion="2 videos cortos (30-60 seg) para redes sociales.")
accion3 = Accion.objects.create(nombre="BTL (Pyme 1 año)",
                                 descripcion="Diseño de material pop (flyers, stickers) o activaciones locales.")
accion4 = Accion.objects.create(nombre="Digital (Pyme 1 año)",
                                 descripcion="Desarrollo de sitio web básico (onepage, responsive) o perfil optimizado en redes.")
accion5 = Accion.objects.create(nombre="Capacitación (Pyme 1 año)",
                                 descripcion="1 taller (2 horas) sobre gestión de marca personal o redes sociales.")
paquete2.acciones.add(accion1, accion2, accion3, accion4, accion5)

paquete3 = Paquete.objects.create(
    plan=plan2,
    ideal_para="Negocios locales B2C/B2B que buscan expansión, fidelización o diferenciación.",
    duracion="6 meses",
    soporte="Reportes bimensuales, ajuste de estrategias según KPIs.",
    entregables="Manual de marca actualizado, videos, material ferial, app/web, informes.",
    kpis_sugeridos="Incremento en ventas (10-15%), Leads generados (50-100), Retención de clientes (20%).",
    precio_minimo=3500,
    precio_maximo=5000
)

accion1 = Accion.objects.create(nombre="Branding/Rebranding (Crecimiento 6 meses)",
                                 descripcion="Desarrollo o actualización de identidad visual (logo, manual de marca, aplicaciones).")
accion2 = Accion.objects.create(nombre="Comunicación Audiovisual (Crecimiento 6 meses)",
                                 descripcion="4 videos (1-2 min) para campañas o contenido de valor.")
accion3 = Accion.objects.create(nombre="BTL/Exhibiciones (Crecimiento 6 meses)",
                                 descripcion="Material para ferias (banners, stands) o activaciones BTL personalizadas.")
accion4 = Accion.objects.create(nombre="Tecnología (Crecimiento 6 meses)",
                                 descripcion="Aplicación móvil básica (iOS/Android) o sistema web (e-commerce simple).")
accion5 = Accion.objects.create(nombre="Capacitación (Crecimiento 6 meses)",
                                 descripcion="2 talleres (3 horas c/u) sobre liderazgo, marketing digital o tics IA.")
paquete3.acciones.add(accion1, accion2, accion3, accion4, accion5)

paquete4 = Paquete.objects.create(
    plan=plan2,
    ideal_para="Negocios locales B2C/B2B que buscan expansión, fidelización o diferenciación.",
    duracion="1 año",
    soporte="Reportes bimensuales, ajuste de estrategias según KPIs.",
    entregables="Manual de marca actualizado, videos, material ferial, app/web, informes.",
    kpis_sugeridos="Incremento en ventas (10-15%), Leads generados (50-100), Retención de clientes (20%).",
    precio_minimo=6500,
    precio_maximo=8000
)

accion1 = Accion.objects.create(nombre="Branding/Rebranding (Crecimiento 1 año)",
                                 descripcion="Desarrollo o actualización de identidad visual (logo, manual de marca, aplicaciones).")
accion2 = Accion.objects.create(nombre="Comunicación Audiovisual (Crecimiento 1 año)",
                                 descripcion="4 videos (1-2 min) para campañas o contenido de valor.")
accion3 = Accion.objects.create(nombre="BTL/Exhibiciones (Crecimiento 1 año)",
                                 descripcion="Material para ferias (banners, stands) o activaciones BTL personalizadas.")
accion4 = Accion.objects.create(nombre="Tecnología (Crecimiento 1 año)",
                                 descripcion="Aplicación móvil básica (iOS/Android) o sistema web (e-commerce simple).")
accion5 = Accion.objects.create(nombre="Capacitación (Crecimiento 1 año)",
                                 descripcion="2 talleres (3 horas c/u) sobre liderazgo, marketing digital o tics IA.")
paquete4.acciones.add(accion1, accion2, accion3, accion4, accion5)

paquete5 = Paquete.objects.create(
    plan=plan3,
    ideal_para="Empresas nacionales B2B/B2C que buscan rebranding, expansión o sistemas tecnológicos avanzados.",
    duracion="1 año",
    soporte="Reportes mensuales, consultoría estratégica, ajustes continuos.",
    entregables="Estrategia de marca completa, campaña audiovisual, sistema tecnológico, informes detallados.",
    kpis_sugeridos="Incremento en market share (5-10%), ROI de campaña (20%), Automatización de procesos (30%).",
    precio_minimo=12000,
    precio_maximo=18000
)

accion1 = Accion.objects.create(nombre="Branding/Rebranding (Estratégico 1 año)",
                                 descripcion="Estrategia 360 (identidad visual, narrativa de marca, posicionamiento).")
accion2 = Accion.objects.create(nombre="Comunicación Audiovisual (Estratégico 1 año)",
                                 descripcion="6-8 videos (1-3 min), jingles o campañas multiplataforma.")
accion3 = Accion.objects.create(nombre="BTL/Exhibiciones (Estratégico 1 año)",
                                 descripcion="Stands personalizados, maquetas 3D para eventos o material POP premium.")
accion4 = Accion.objects.create(nombre="Tecnología (Estratégico 1 año)",
                                 descripcion="Sistema web/ecommerce avanzado o app con funcionalidades personalizadas.")
accion5 = Accion.objects.create(nombre="Capacitación (Estratégico 1 año)",
                                 descripcion="Programa integral (4 talleres, 4 horas c/u) sobre innovación, comunicación o automatización.")
paquete5.acciones.add(accion1, accion2, accion3, accion4, accion5)
print("Paquetes creados exitosamente.")

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
print("Empresas creadas exitosamente.")
time.sleep(1)
print("Base de datos poblada exitosamente.")
time.sleep(1)