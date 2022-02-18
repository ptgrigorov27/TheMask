# Create PubSub topics and subscriptions 
gcloud pubsub topics create twitter-trigger
gcloud pubsub topics create twitter-response
gcloud pubsub topics create twitter-parsed
gcloud pubsub topics create twitter-to-bq
gcloud pubsub subscriptions create twitter-trigger-sub --topic twitter-trigger
gcloud pubsub subscriptions create twitter-response-sub --topic twitter-response
gcloud pubsub subscriptions create twitter-parsed-sub --topic twitter-parsed
gcloud pubsub subscriptions create twitter-to-bq-sub --topic twitter-to-bq

# Deploy cloud functions 
# (note that this looks cumbersome because the deployment script needs to be in the 
# same directory as the CloudFunction code and because the CloudFunction needs be 
# be names main.py)
cd 01TwitterApiConnector/
sh deploy-cloud-function.sh

cd ..
cd 02TwitterApiParser/
sh deploy-cloud-function.sh

cd ..
cd 03SentimentModel/
sh deploy-cloud-function.sh


gsutil mb -p crypto-sentiment-341504 gs://crypto-sentiment-341504-twitter-to-bq-dataflow

gcloud dataflow jobs run twitter-to-bq-dataflow \
    --gcs-location gs://dataflow-templates/latest/PubSub_Subscription_to_BigQuery \
    --staging-location gs://crypto-sentiment-341504-twitter-to-bq-dataflow \
    --parameters \
    inputSubscription=projects/crypto-sentiment-341504/subscriptions/twitter-to-bq-sub,\
    outputTableSpec=crypto-sentiment-341504:crypto_sentiment.tmp

# Use Cloud scheduler to trigger via pubsub
gcloud scheduler jobs create pubsub twitter-trigger-cloud-scheduler \
    --location=us-central1 \
    --schedule "*/1 * * * *" \
    --topic twitter-trigger \
    --message-body "Hello from trigger"
