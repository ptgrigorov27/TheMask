gcloud functions deploy coin_request_from_api \
    --entry-point coin_request_from_api \
    --runtime python39 \
    --trigger-topic coin-trigger
