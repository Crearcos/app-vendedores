from django.contrib.auth.models import User
from usuarios.models import UserProfile
from empresas.models import Empresa

# Crear usuario administrador con correo y contraseña
user = User.objects.create_user(username="admin1", email="admin@example.com", password="admin123")

# Asignar el rol de Administrador
UserProfile.objects.create(user=user, role="administrador")

# Crear usuario vendedor con correo y contraseña
user = User.objects.create_user(username="vendedor1", email="vendedor@example.com", password="vendedor123")

# Asignar el rol de Vendedor
UserProfile.objects.create(user=user, role="vendedor")

empresa = Empresa.objects.create(nombre_empresa="ANTONELLA ZAMBRANO", tipo_empresa="PYME", respresentante="ANTONELLA ZAMBRANO",cargo="Titular", modo_contacto="WHATSAPP", telefono="0960869531")
empresa = Empresa.objects.create(nombre_empresa="TELSYNET", tipo_empresa="PYME", respresentante="CARLOS PONCE",cargo="GERENTE", modo_contacto="LLAMADA", telefono="0967613154")
empresa = Empresa.objects.create(nombre_empresa="FINCA DOMONTI", tipo_empresa="PYME", respresentante="DANIEL DOBRONSKI",cargo="FUNDADOR",email="fincadomonti@outlook.com", modo_contacto="WHATSAPP", telefono="0998113842")
empresa = Empresa.objects.create(nombre_empresa="FERNANDO BERNAL", tipo_empresa="PYME", respresentante="FERNANDO BERNAL",cargo="TITULAR", modo_contacto="WHATSAPP", telefono="0968919264")
empresa = Empresa.objects.create(nombre_empresa="COSMOSEG", tipo_empresa="PYME", respresentante="JOHN CABEZAS",cargo="SOCIO", modo_contacto="LLAMADA", telefono="0987592519")
empresa = Empresa.objects.create(nombre_empresa="ECHOARTE", tipo_empresa="PYME", respresentante="JORGE ROBY",cargo="DUEÑO", modo_contacto="LLAMADA", telefono="0961102517")
empresa = Empresa.objects.create(nombre_empresa="SOMBREROS", tipo_empresa="PYME", respresentante="MARIO PACHECO",cargo="DUEÑO", modo_contacto="LLAMADA", telefono="0979692701")
empresa = Empresa.objects.create(nombre_empresa="BIGEME S.A.", tipo_empresa="PYME", respresentante="SEBASTIAN FREIRE", modo_contacto="LLAMADA", telefono="0984292570")
empresa = Empresa.objects.create(nombre_empresa="EL OBRAJE", tipo_empresa="PYME", respresentante="G. COMERCIAL",cargo="WHATSAPP", modo_contacto="WHATSAPP", telefono="0999901087")
empresa = Empresa.objects.create(nombre_empresa="FABRIMASA", tipo_empresa="PYME", respresentante="WENDY MONTIEL",cargo="TGERENTE GENERAL", modo_contacto="LLAMADA", telefono="0991056175 / 0426029868")
empresa = Empresa.objects.create(nombre_empresa="ECUSCIENCE", tipo_empresa="PYME", respresentante="KARINA ORTEGA",cargo="REPRESENTANTE COMERCIAL", modo_contacto="WHATSAPP", telefono="00993404980")
empresa = Empresa.objects.create(nombre_empresa="SOFTWARE EVOLUTIVO", tipo_empresa="PYME", respresentante="OLIVIA",email="olivia@softwareevolutivo.net", modo_contacto="WHATSAPP", telefono="0979733071")
empresa = Empresa.objects.create(nombre_empresa="CARBONO NEUTRAL", tipo_empresa="PYME", respresentante="RAFAEL URQUIZO",cargo="JEFE DE MARKETING", email="rafaelurquizo@carbononeutral.com.ec", modo_contacto="WHATSAPP", telefono="0980015077")
empresa = Empresa.objects.create(nombre_empresa="FINCA DOMONTI", tipo_empresa="PYME", respresentante="DANIEL DOBRONSKI",cargo="FUNDADOR", email="fincadomonti@outlook.com",modo_contacto="WHATSAPP", telefono="0998113842")
empresa = Empresa.objects.create(nombre_empresa="LOGUN S.A.", tipo_empresa="PYME", respresentante="THALIA ALVARADO",cargo="TBUSINESS EXECUTIVE",email= "talvarado@grupoholco.com", modo_contacto="WHATSAPP", telefono="0968060501")
