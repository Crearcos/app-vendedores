from django.db import models
from django.utils import timezone

class Empresa(models.Model):
    # Tipos de empresa comunes
    TIPO_EMPRESA_CHOICES = [
        ('PYME', 'Pequeña y Mediana Empresa'),
        ('CORP', 'Corporación'),
        ('STARTUP', 'Startup'),
        ('ONG', 'Organización No Gubernamental'),
        ('GUB', 'Entidad Gubernamental'),
    ]

    # Modos de contacto disponibles
    MODO_CONTACTO_CHOICES = [
        ('EMAIL', 'Correo Electrónico'),
        ('WHATSAPP', 'WhatsApp'),
        ('LLAMADA', 'Llamada Telefónica'),
        ('VISITA', 'Visita Presencial'),
    ]

    nombre = models.CharField(
        max_length=255, 
        verbose_name='Nombre de la Empresa',
        help_text='Nombre legal registrado'
    )
    nit = models.CharField(
        max_length=20, 
        unique=True,
        verbose_name='NIT',
        help_text='Número de Identificación Tributaria'
    )
    tipo_empresa = models.CharField(
        max_length=50,
        choices=TIPO_EMPRESA_CHOICES,
        default='PYME',
        verbose_name='Tipo de Empresa'
    )
    giro = models.CharField(
        max_length=255,
        verbose_name='Giro Empresarial',
        help_text='Rubro principal de la empresa',
        default=''
    )
    contacto = models.CharField(
        max_length=255,
        verbose_name='Nombre del Contacto',
        help_text='Persona de contacto principal'
    )
    cargo = models.CharField(
        max_length=255,
        verbose_name='Cargo del Contacto',
        help_text='Puesto del contacto en la empresa'
    )
    telefono = models.CharField(
        max_length=20,
        verbose_name='Teléfono de Contacto',
        help_text='Número con código de país y área'
    )
    especialidad_negocio = models.TextField(
        verbose_name='Especialidad del Negocio',
        help_text='Detalle de las especialidades comerciales',
        default=""
    )
    necesidad_especifica = models.TextField(
        verbose_name='Necesidad Específica',
        help_text='Requerimientos particulares del cliente',
        default=''
    )
    ciudad = models.CharField(
        max_length=100,
        verbose_name='Ciudad',
        help_text='Ciudad donde opera la empresa'
    )
    direccion = models.TextField(
        verbose_name='Dirección Completa',
        help_text='Domicilio fiscal o comercial',
        default=""
    )
    modo_contacto = models.CharField(
        max_length=50,
        choices=MODO_CONTACTO_CHOICES,
        default='EMAIL',
        verbose_name='Preferencia de Contacto'
    )
    fecha_registro = models.DateTimeField(
        default=timezone.now,
        verbose_name='Fecha de Registro'
    )
    ultima_actualizacion = models.DateTimeField(
        auto_now=True,
        verbose_name='Última Actualización'
    )

    class Meta:
        verbose_name = 'Empresa'
        verbose_name_plural = 'Empresas'
        ordering = ['-fecha_registro']
        indexes = [
            models.Index(fields=['nombre']),
            models.Index(fields=['ciudad']),
            models.Index(fields=['tipo_empresa']),
        ]

    def __str__(self):
        return f"{self.nombre} ({self.get_tipo_empresa_display()})"

    @property
    def contacto_completo(self):
        return f"{self.contacto} - {self.cargo}"
