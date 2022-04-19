# Marc Meier-Dornberg

# Create PubSub topics and subscriptions 
gcloud pubsub topics create coin-trigger
gcloud pubsub subscriptions create coin-trigger-sub --topic coin-trigger

# Deploy cloud functions 
cd 01CoinApiConnector/
sh deploy-cloud-function.sh

# Use Cloud scheduler to trigger via pubsub
gcloud scheduler jobs create pubsub coin-trigger-cloud-scheduler \
    --location=us-central1 \
    --schedule "*/15 * * * *" \
    --topic coin-trigger \
    --message-body "Cloud schedule trigger Coin API"
