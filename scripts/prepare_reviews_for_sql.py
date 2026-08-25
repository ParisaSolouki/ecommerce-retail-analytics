from pathlib import Path

import pandas as pd


# Resolve project directories relative to this script
project_root = Path(__file__).resolve().parents[1]

source_path = (
    project_root
    / "data"
    / "raw"
    / "olist_order_reviews_dataset.csv"
)

output_path = (
    project_root
    / "data"
    / "processed"
    / "reviews_sql.csv"
)


# Load the original reviews dataset
reviews = pd.read_csv(source_path)


# Retain only the columns required for SQL analysis
sql_columns = [
    "review_id",
    "order_id",
    "review_score",
    "review_creation_date",
    "review_answer_timestamp",
]

reviews_sql = reviews[sql_columns].copy()


# Export the SQL-compatible reviews dataset
reviews_sql.to_csv(
    output_path,
    index=False,
    encoding="utf-8",
    lineterminator="\n",
)


print(f"Rows exported: {len(reviews_sql):,}")
print(f"File created: {output_path}")

