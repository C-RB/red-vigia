import argparse
from datetime import datetime, timezone
from pathlib import Path

import pandas as pd
from ultralytics import YOLO

IMAGE_EXTENSIONS = {".jpg", ".jpeg", ".png"}


def detect(source: Path, model_path: str) -> pd.DataFrame:
    model = YOLO(model_path)
    rows = []
    for image_path in sorted(p for p in source.iterdir() if p.suffix.lower() in IMAGE_EXTENSIONS):
        timestamp = datetime.now(timezone.utc)
        result = model(image_path, verbose=False)[0]
        for box in result.boxes:
            x1, y1, x2, y2 = (float(v) for v in box.xyxy[0])
            rows.append(
                {
                    "archivo": image_path.name,
                    "class_name": result.names[int(box.cls)],
                    "confianza": float(box.conf),
                    "x1": x1,
                    "y1": y1,
                    "x2": x2,
                    "y2": y2,
                    "timestamp": timestamp,
                    "latitud": None,
                    "longitud": None,
                }
            )
    return pd.DataFrame(rows)


def main() -> None:
    parser = argparse.ArgumentParser(description="Detecta hallazgos en imágenes de torres eléctricas.")
    parser.add_argument("--source", type=Path, required=True, help="Carpeta con imágenes")
    parser.add_argument("--model", default="yolov8n.pt", help="Ruta o nombre del modelo YOLO")
    parser.add_argument("--out", type=Path, required=True, help="Archivo parquet de salida")
    args = parser.parse_args()

    df = detect(args.source, args.model)
    args.out.parent.mkdir(parents=True, exist_ok=True)
    df.to_parquet(args.out, index=False)
    print(f"{len(df)} detecciones guardadas en {args.out}")


if __name__ == "__main__":
    main()
