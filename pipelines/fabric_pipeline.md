# Pipeline en Microsoft Fabric

Orquestación con Data Factory (Data Pipelines) sobre un Lakehouse.

## Flujo

1. **Trigger**: ejecución programada o al subir imágenes nuevas a `Files/imagenes/`.
2. **Detección**: notebook que llama a `src/detection/detect.py` y genera el parquet de detecciones.
3. **Bronze**: carga del parquet en `bronze.detecciones` (`sql/01_bronze.sql`).
4. **Silver**: limpieza, deduplicación y criticidad (`sql/02_silver.sql`).
5. **Gold**: vistas `ranking_criticidad` y `tendencia_diaria` (`sql/03_gold.sql`).
6. **Power BI**: el modelo semántico lee las vistas de gold, con actualización después del paso 5.
7. **Alerta**: si el número de hallazgos críticos supera un umbral, se envía notificación.

## Pendiente de definir

- Frecuencia de ejecución.
- Umbral de alerta para hallazgos críticos.
- Fuente de latitud y longitud (hoy son `NULL` como placeholder).
