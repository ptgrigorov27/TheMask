# Create dataset
bq mk crypto_sentiment

# bq rm --table=true crypto-sentiment-341504:crypto_sentiment.tmp

# Create table
bq mk --table \
    --description "This table contains tweets with extracted attributes and a computed sentiment score" \
    crypto-sentiment-341504:crypto_sentiment.tweets_prepared \
    "id:INT64,\
    text:STRING,\
    author_id:INT64,\
    conversation_id:INT64,\
    created_at:TIMESTAMP,\
    place_id:STRING,\
    in_reply_to_user_id:INT64,\
    lang:STRING,\
    retweet_count:INT64,\
    reply_count:INT64,\
    like_count:INT64,\
    neg_Sentiment:FLOAT64,\
    pos_Sentiment:FLOAT64,\
    compound_Sentiment:FLOAT64,\
    ingest_timestamp:TIMESTAMP"