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

bq mk --table \
    --description "This table contains OHLCV (Open, High, Low, Close, Volume) bitcoin data from the Coin API" \
    crypto-sentiment-341504:crypto_sentiment.bitcoin_ohlcv \
    "time_period_start:TIMESTAMP, 
    time_period_end:TIMESTAMP, 
    time_open:TIMESTAMP, 
    time_close:TIMESTAMP, 
    price_open:FLOAT64, 
    price_high:FLOAT64, 
    price_low:FLOAT64, 
    price_close:FLOAT64, 
    volume_traded:FLOAT64, 
    trades_count:INT64, 
    ingest_timestamp:TIMESTAMP"