# Create PubSub topics and subscriptions 
gcloud pubsub topics create twitter-trigger
gcloud pubsub topics create twitter-to-bq
gcloud pubsub subscriptions create twitter-trigger-sub --topic twitter-trigger
gcloud pubsub subscriptions create twitter-to-bq-sub --topic twitter-to-bq

# Deploy cloud functions 
cd cloud-function_twitter_request_from_api/
sh deploy-cloud-function.sh


# GCS bucket as a deployment location for the pubsub-to-bq dataflow
gsutil mb -p crypto-sentiment-341504 gs://crypto-sentiment-341504-twitter-to-bq-dataflow

# deploying a predefined pubsub to bq dataflow template
gcloud dataflow jobs run twitter-to-bq-dataflow \
    --gcs-location gs://dataflow-templates/latest/PubSub_Subscription_to_BigQuery \
    --staging-location gs://crypto-sentiment-341504-twitter-to-bq-dataflow \
    --parameters \
    inputSubscription=projects/crypto-sentiment-341504/subscriptions/twitter-to-bq-sub,outputTableSpec=crypto-sentiment-341504:crypto_sentiment.tweets_prepared

# Use Cloud scheduler to trigger via pubsub
gcloud scheduler jobs create pubsub twitter-trigger-cloud-scheduler \
    --location=us-central1 \
    --schedule "*/1 * * * *" \
    --topic twitter-trigger \
    --message-body "Cloud schedule trigger Twitter API"