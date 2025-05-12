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
        ('OTRO', 'Otro tipo de organización'),
    ]

    # Modos de contacto disponibles
    MODO_CONTACTO_CHOICES = [
        ('EMAIL', 'Correo Electrónico'),
        ('WHATSAPP', 'WhatsApp'),
        ('LLAMADA', 'Llamada Telefónica'),
        ('VISITA', 'Visita Presencial'),
        ('VIDEOCALL', 'Videollamada'),
    ]

    # Campos principales
    nombre_empresa = models.CharField(
        max_length=255, 
        verbose_name='Nombre de la Empresa',
        help_text='Nombre legal registrado'
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
        help_text='Rubro principal de la empresa'
    )

    # Información de contacto
    representante = models.CharField(
        max_length=255,
        verbose_name='Nombre del Representante',
        help_text='Persona de contacto principal'
    )

    cargo = models.CharField(
        max_length=255,
        verbose_name='Cargo del Representante',
        help_text='Puesto del representante en la empresa',
        blank=True,
        null=True
    )

    email = models.EmailField(
        verbose_name='Correo Electrónico',
        help_text='Email de contacto principal',
        blank=True,
        null=True
    )

    telefono = models.CharField(
        max_length=20,
        verbose_name='Teléfono de Contacto',
        help_text='Número con código de país y área',
        blank=True,
        null=True
    )

    modo_contacto = models.CharField(
        max_length=50,
        choices=MODO_CONTACTO_CHOICES,
        default='EMAIL',
        verbose_name='Preferencia de Contacto'
    )

    # Ubicación
    ciudad = models.CharField(
        max_length=100,
        verbose_name='Ciudad',
        help_text='Ciudad donde opera la empresa',
        blank=True,
        null=True
    )

    direccion = models.TextField(
        verbose_name='Dirección Completa',
        help_text='Domicilio fiscal o comercial',
        blank=True,
        null=True
    )

    # Información comercial
    necesidad_detectada = models.TextField(
        verbose_name='Necesidad Detectada',
        help_text='Requerimientos particulares del cliente'
    )

    producto_servicio_interes = models.TextField(
        verbose_name='Producto/Servicio de Interés',
        help_text='Productos o servicios que la empresa necesita',
        blank=True,
        null=True
    )

    # Agendamiento
    proxima_cita = models.DateTimeField(
        verbose_name='Próxima Cita',
        help_text='Fecha y hora de la próxima cita programada',
        blank=True,
        null=True
    )

    notas_cita = models.TextField(
        verbose_name='Notas de la Cita',
        help_text='Observaciones o preparación para la próxima cita',
        blank=True,
        null=True
    )

    # Metadata
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
            models.Index(fields=['nombre_empresa']),
            models.Index(fields=['ciudad']),
            models.Index(fields=['tipo_empresa']),
            models.Index(fields=['proxima_cita']),
        ]

    def __str__(self):
        return f"{self.nombre_empresa} ({self.get_tipo_empresa_display()}) - {self.ciudad or 'Sin ciudad'}"

    @property
    def contacto_completo(self):
        return f"{self.representante} ({self.cargo or 'Sin cargo'}) - {self.telefono or 'Sin teléfono'}"

    @property
    def tiene_cita_programada(self):
        return self.proxima_cita is not None
