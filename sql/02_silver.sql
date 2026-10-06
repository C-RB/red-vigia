-- Silver: limpieza, deduplicación y criticidad por clase.
CREATE OR REPLACE TABLE silver.detecciones USING DELTA AS
WITH limpias AS (
    SELECT DISTINCT
        archivo,
        class_name,
        confianza,
        x1, y1, x2, y2,
        timestamp,
        latitud,
        longitud
    FROM bronze.detecciones
    WHERE confianza >= 0.25
      AND class_name IS NOT NULL
)
SELECT
    *,
    CASE
        WHEN class_name IN ('Insulator Damaged', 'Conducting Wire Misconnection', 'Earth Wire Faulty')
            THEN 'critico'
        WHEN class_name IN ('Vegetation', 'Foreign Object', 'Loose Bolt and Nut', 'Corona Ring Missing')
            THEN 'alerta'
        ELSE 'informativo'
    END AS criticidad
FROM limpias;
