# Create dataset
bq mk crypto_sentiment

# bq rm --table=true crypto-sentiment-341504:crypto_sentiment.tmp

# Create table
bq mk --table \
    --description "Temp table for testing purposes" \
    crypto-sentiment-341504:crypto_sentiment.tmp \
    "message:STRING,\
    ingest_timestamp:TIMESTAMP"



# TODO: Add table creation
# https://cloud.google.com/bigquery/docs/reference/bq-cli-reference