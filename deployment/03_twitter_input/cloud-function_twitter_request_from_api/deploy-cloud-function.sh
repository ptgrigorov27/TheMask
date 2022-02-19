gcloud functions deploy twitter_request_from_api \
    --entry-point twitter_request_from_api \
    --runtime python39 \
    --trigger-topic twitter-trigger
