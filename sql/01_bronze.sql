-- Bronze: detecciones crudas tal como salen de detect.py, sin transformar.
CREATE TABLE IF NOT EXISTS bronze.detecciones (
    archivo     STRING,
    class_name  STRING,
    confianza   DOUBLE,
    x1          DOUBLE,
    y1          DOUBLE,
    x2          DOUBLE,
    y2          DOUBLE,
    timestamp   TIMESTAMP,
    latitud     DOUBLE,
    longitud    DOUBLE
) USING DELTA;
