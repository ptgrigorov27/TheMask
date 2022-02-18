# Create a service account for PubSub

gcloud iam service-accounts create service-pubsub \
    --description="Service account for PubSub" \
    --display-name="service-pubsub"
    
gcloud projects add-iam-policy-binding crypto-sentiment-341504 \
    --member="serviceAccount:service-pubsub@crypto-sentiment-341504.iam.gserviceaccount.com" \
    --role="roles/pubsub.admin"