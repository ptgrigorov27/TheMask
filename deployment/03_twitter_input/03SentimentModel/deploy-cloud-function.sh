gcloud functions deploy twitter_compute_sentiment_score \
    --entry-point twitter_compute_sentiment_score \
    --runtime python39 \
    --trigger-topic twitter-parsed
