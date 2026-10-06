-- Gold: KPIs listos para Power BI.

-- Ranking de criticidad por imagen (y ubicación, cuando exista).
CREATE OR REPLACE VIEW gold.ranking_criticidad AS
SELECT
    archivo,
    latitud,
    longitud,
    COUNT(*)                                        AS total_hallazgos,
    SUM(CASE WHEN criticidad = 'critico' THEN 1 ELSE 0 END) AS hallazgos_criticos,
    SUM(CASE WHEN criticidad = 'alerta' THEN 1 ELSE 0 END)  AS hallazgos_alerta,
    ROUND(AVG(confianza), 3)                        AS confianza_promedio
FROM silver.detecciones
GROUP BY archivo, latitud, longitud
ORDER BY hallazgos_criticos DESC, total_hallazgos DESC;

-- Tendencia diaria de hallazgos por criticidad.
CREATE OR REPLACE VIEW gold.tendencia_diaria AS
SELECT
    CAST(timestamp AS DATE) AS fecha,
    criticidad,
    COUNT(*)                AS total_hallazgos
FROM silver.detecciones
GROUP BY CAST(timestamp AS DATE), criticidad;
