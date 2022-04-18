# Create model
# # Marian Marin, Marc Meier-Dornburg, Gabrielle Stoney
bq query \
--use_legacy_sql=false \
'CREATE OR REPLACE MODEL `crypto-sentiment-341504.crypto_sentiment.bitcoin_model`
OPTIONS (model_type="linear_reg", input_label_cols=["next_period_price_movement"], data_split_method="random", data_split_eval_fraction=0.2) AS
SELECT 
bitcoin.avg_compound_sentiment, bitcoin.avg_neg_sentiment, bitcoin.avg_pos_sentiment, bitcoin.volume_traded, 
bitcoin.tweets_count, bitcoin.trades_count, bitcoin.price_open,
bitcoin.price_close, bitcoin.next_period_price_movement
FROM
`crypto-sentiment-341504.crypto_sentiment.bitcoin_sentiments_consolidated` as bitcoin
WHERE 
next_period_price_movement IS NOT NULL;'
