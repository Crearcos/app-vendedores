from django.db import models

class Plan(models.Model):
    nombre = models.CharField(max_length=255, unique=True)

    def __str__(self):
        return self.nombre

class Tarifario(models.Model):
    plan = models.ForeignKey(Plan, on_delete=models.CASCADE)
    duracion = models.CharField(max_length=50, default="Indefinido")
    costo_total_minimo = models.DecimalField(max_digits=10, decimal_places=2)
    costo_total_maximo = models.DecimalField(max_digits=10, decimal_places=2)
    costo_mensual_minimo = models.DecimalField(max_digits=10, decimal_places=2)
    costo_mensual_maximo = models.DecimalField(max_digits=10, decimal_places=2)
    notas = models.TextField(blank=True, null=True)

class Accion(models.Model):
    nombre = models.CharField(max_length=255, unique=True)
    descripcion = models.TextField()

    def __str__(self):
        return self.nombre

class Paquete(models.Model):
    plan = models.ForeignKey(Plan, on_delete=models.CASCADE)
    ideal_para = models.TextField()
    duracion = models.CharField(max_length=50)
    soporte = models.TextField()
    entregables = models.TextField()
    kpis_sugeridos = models.TextField()
    precio_minimo = models.DecimalField(max_digits=10, decimal_places=2)
    precio_maximo = models.DecimalField(max_digits=10, decimal_places=2)
    acciones = models.ManyToManyField(Accion, related_name="paquetes")

    def __str__(self):
        return f"Paquete {self.plan.nombre} - {self.duracion}"
