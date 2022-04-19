# Marc Meier-Dornberg

# Create PubSub topics and subscriptions 
gcloud pubsub topics create twitter-trigger
gcloud pubsub subscriptions create twitter-trigger-sub --topic twitter-trigger

# Deploy cloud functions 
cd cloud-function_twitter_request_from_api/
sh deploy-cloud-function.sh

# Use Cloud scheduler to trigger via pubsub
gcloud scheduler jobs create pubsub twitter-trigger-cloud-scheduler \
    --location=us-central1 \
    --schedule "*/1 * * * *" \
    --topic twitter-trigger \
    --message-body "Cloud schedule trigger Twitter API"
