# red-vigia

Pipeline de visión computacional que detecta elementos de infraestructura eléctrica y posibles fallas en imágenes aéreas, organiza los resultados en capas de datos SQL (bronze, silver, gold) y los deja listos para un dashboard en Power BI.

## Alcance

- **Entrada**: imágenes de torres y tendidos eléctricos.
- **Detección**: modelo YOLO que identifica 9 tipos de hallazgos (aisladores dañados, vegetación, objetos extraños, pernos flojos, entre otros).
- **Procesamiento**: limpieza, deduplicación y clasificación por criticidad (crítico, alerta, informativo).
- **Salida**: KPIs de criticidad por ubicación y tendencia diaria para visualizar en Power BI.
- **Plataforma objetivo**: Microsoft Fabric (Lakehouse, Data Pipelines).

Limitación: el modelo se entrena con un dataset público de Roboflow (Transmission Towers, v7, licencia CC BY 4.0). Es una prueba de concepto; para uso real habría que reentrenarlo con imágenes propias de la infraestructura que se quiera monitorear.

## Arquitectura

```
Imágenes de torres
      │
      ▼
src/detection/detect.py      Detección con YOLO → parquet de detecciones
      │
      ▼
Bronze  sql/01_bronze.sql    Datos crudos tal como salen del modelo (Delta)
      │
      ▼
Silver  sql/02_silver.sql    Limpieza, deduplicación y criticidad por clase
      │
      ▼
Gold    sql/03_gold.sql      ranking_criticidad y tendencia_diaria
      │
      ▼
Power BI                     Dashboard y alertas por hallazgos críticos
```

La orquestación en Fabric está en [pipelines/fabric_pipeline.md](pipelines/fabric_pipeline.md).

## Estructura

```
red-vigia/
├── README.md
├── requirements.txt
├── .gitignore
├── data/
│   └── transmission-towers/     Dataset YOLOv8 (no se versiona)
├── src/detection/detect.py
├── sql/
│   ├── 01_bronze.sql
│   ├── 02_silver.sql
│   └── 03_gold.sql
└── pipelines/fabric_pipeline.md
```

## Uso

```bash
pip install -r requirements.txt
python src/detection/detect.py --source data/transmission-towers/valid/images --model yolov8n.pt --out data/detections.parquet
```

El modelo `yolov8n.pt` es genérico (COCO). Un fine-tuning con el dataset de torres está pendiente.

## Estado

- [x] Estructura del repositorio
- [x] Dataset descargado
- [ ] Script de detección probado
- [ ] Capas SQL probadas en entorno local
- [ ] Pipeline en Fabric
- [ ] Dashboard en Power BI
- [ ] Mapa de ubicaciones (QGIS)
- [ ] Capturas y video demo
