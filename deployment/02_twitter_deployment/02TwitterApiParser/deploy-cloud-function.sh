gcloud functions deploy twitter_parse_message \
    --entry-point twitter_parse_message \
    --runtime python39 \
    --trigger-topic twitter-response
