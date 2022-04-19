# Create the view tweets_filtered from tweets_prepared
# The view filteres out tweets without a sentiment score and tweets in another language than English
# so that the view only contains useful sentiment scores
# Marc Meier-Dornberg
bq mk \
    --use_legacy_sql=false \
    --expiration 0 \
    --description "This view contains tweets with extracted attributes and a computed sentiment score, non-english tweets and tweets without sentiment score are removed" \
    --view 'SELECT 
                * 
            FROM 
                `crypto-sentiment-341504.crypto_sentiment.tweets_prepared` 
            WHERE 
                lang="en" AND 
                (neg_Sentiment <> 0 or pos_Sentiment <> 0 or compound_Sentiment <> 0)' \
    --project_id crypto-sentiment-341504 \
    crypto_sentiment.tweets_filtered
