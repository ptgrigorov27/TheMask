# Create the table bitcoin_sentiments_consolidated from bitcoin_ohlcv and tweets_filtered
# The table bitcoin_sentiments_consolidated aggregates the data from the two bitcoin_ohlcv and tweets_filtered
# The query run every hour and rewrite the table
# Mariah Marin, Gabrielle Stoney
bq query \
    --use_legacy_sql=false \
    --destination_table=crypto_sentiment.output \
    --display_name='Scheduled Query to overwrite output every hour' \
    --schedule='every 1 hours' \
    --replace=true \
    'SELECT 
        OUTPUT.next_period_id AS period_id, 
        BASE.price_close,
        BASE.price_open, 
        BASE.price_high, 
        BASE.price_low, 
        BASE.volume_traded, 
        BASE.trades_count, 
        BASE.avg_neg_sentiment,
        BASE.avg_pos_sentiment, 
        BASE.avg_compound_sentiment, 
        OUTPUT.next_period_price_movement as price_movement, 
        OUTPUT.predicted_next_period_price_movement as predicted_price_movement, 
        OUTPUT.predicted_next_period_price_close as predicted_price_close
    FROM `crypto-sentiment-341504.crypto_sentiment.bitcoin_sentiments_consolidated` BASE 
    FULL OUTER JOIN `crypto-sentiment-341504.crypto_sentiment.model_output` OUTPUT
    ON BASE.period_id = OUTPUT.next_period_id
    order by OUTPUT.next_period_id desc'


