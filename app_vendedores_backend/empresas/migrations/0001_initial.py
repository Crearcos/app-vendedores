
import django.utils.timezone
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Empresa',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('nombre_empresa', models.CharField(help_text='Nombre legal registrado', max_length=255, verbose_name='Nombre de la Empresa')),
                ('tipo_empresa', models.CharField(choices=[('PYME', 'Pequeña y Mediana Empresa'), ('CORP', 'Corporación'), ('STARTUP', 'Startup'), ('ONG', 'Organización No Gubernamental'), ('GUB', 'Entidad Gubernamental'), ('OTRO', 'Otro tipo de organización')], default='PYME', max_length=50, verbose_name='Tipo de Empresa')),
                ('giro', models.CharField(help_text='Rubro principal de la empresa', max_length=255, verbose_name='Giro Empresarial')),
                ('representante', models.CharField(help_text='Persona de contacto principal', max_length=255, verbose_name='Nombre del Representante')),
                ('cargo', models.CharField(help_text='Puesto del representante en la empresa', max_length=255, verbose_name='Cargo del Representante')),
                ('email', models.EmailField(blank=True, help_text='Email de contacto principal', max_length=254, null=True, verbose_name='Correo Electrónico')),
                ('telefono', models.CharField(help_text='Número con código de país y área', max_length=20, verbose_name='Teléfono de Contacto')),
                ('modo_contacto', models.CharField(choices=[('EMAIL', 'Correo Electrónico'), ('WHATSAPP', 'WhatsApp'), ('LLAMADA', 'Llamada Telefónica'), ('VISITA', 'Visita Presencial'), ('VIDEOCALL', 'Videollamada')], default='EMAIL', max_length=50, verbose_name='Preferencia de Contacto')),
                ('ciudad', models.CharField(help_text='Ciudad donde opera la empresa', max_length=100, verbose_name='Ciudad')),
                ('direccion', models.TextField(help_text='Domicilio fiscal o comercial', verbose_name='Dirección Completa')),
                ('necesidad_detectada', models.TextField(help_text='Requerimientos particulares del cliente', verbose_name='Necesidad Detectada')),
                ('producto_servicio_interes', models.TextField(blank=True, help_text='Productos o servicios que la empresa necesita', null=True, verbose_name='Producto/Servicio de Interés')),
                ('proxima_cita', models.DateTimeField(blank=True, help_text='Fecha y hora de la próxima cita programada', null=True, verbose_name='Próxima Cita')),
                ('notas_cita', models.TextField(blank=True, help_text='Observaciones o preparación para la próxima cita', null=True, verbose_name='Notas de la Cita')),
                ('fecha_registro', models.DateTimeField(default=django.utils.timezone.now, verbose_name='Fecha de Registro')),
                ('ultima_actualizacion', models.DateTimeField(auto_now=True, verbose_name='Última Actualización')),
            ],
            options={
                'verbose_name': 'Empresa',
                'verbose_name_plural': 'Empresas',
                'ordering': ['-fecha_registro'],
                'indexes': [models.Index(fields=['nombre_empresa'], name='empresas_em_nombre__e4d137_idx'), models.Index(fields=['ciudad'], name='empresas_em_ciudad_d454c2_idx'), models.Index(fields=['tipo_empresa'], name='empresas_em_tipo_em_4208dc_idx'), models.Index(fields=['proxima_cita'], name='empresas_em_proxima_dcd533_idx')],
            },
        ),
    ]
