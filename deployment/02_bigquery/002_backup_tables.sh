# Marc Meier-Dornberg
bq query \
--destination_table crypto-sentiment-341504:crypto_sentiment.backup_tweets_prepared \
--use_legacy_sql=false \
--replace \
'SELECT * FROM `crypto-sentiment-341504.crypto_sentiment.tweets_prepared`'

bq query \
--destination_table crypto-sentiment-341504:crypto_sentiment.backup_bitcoin_ohlcv \
--use_legacy_sql=false \
--replace \
'SELECT * FROM `crypto-sentiment-341504.crypto_sentiment.bitcoin_ohlcv`'

