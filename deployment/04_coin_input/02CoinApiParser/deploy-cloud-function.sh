gcloud functions deploy coin_parse_message \
    --entry-point coin_parse_message \
    --runtime python39 \
    --trigger-topic coin-response
