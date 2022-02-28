# Create PubSub topics and subscriptions 
gcloud pubsub topics create coin-trigger
gcloud pubsub topics create coin-to-bq
gcloud pubsub subscriptions create coin-trigger-sub --topic coin-trigger
gcloud pubsub subscriptions create coin-to-bq-sub --topic coin-to-bq

# Deploy cloud functions 
cd 01CoinApiConnector/
sh deploy-cloud-function.sh

# GCS bucket as a deployment location for the pubsub-to-bq dataflow
gsutil mb -p crypto-sentiment-341504 gs://crypto-sentiment-341504-coin-to-bq-dataflow

# deploying a predefined pubsub to bq dataflow template
gcloud dataflow jobs run coin-to-bq-dataflow \
    --gcs-location gs://dataflow-templates/latest/PubSub_Subscription_to_BigQuery \
    --region=us-central1 \
    --max-workers=1 \
    --worker-machine-type=e2-standard-2 \
    --staging-location gs://crypto-sentiment-341504-coin-to-bq-dataflow \
    --parameters \
    inputSubscription=projects/crypto-sentiment-341504/subscriptions/coin-to-bq-sub,outputTableSpec=crypto-sentiment-341504:crypto_sentiment.bitcoin_ohlcv

# Use Cloud scheduler to trigger via pubsub
gcloud scheduler jobs create pubsub coin-trigger-cloud-scheduler \
    --location=us-central1 \
    --schedule "*/15 * * * *" \
    --topic coin-trigger \
    --message-body "Cloud schedule trigger Coin API"
