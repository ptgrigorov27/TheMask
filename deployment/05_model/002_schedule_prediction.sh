# schedule query to predict every hour
bq query \
    --use_legacy_sql=false \
    --destination_table=crypto_sentiment.model_output \
    --display_name='Scheduled Query to overwrite model_output which contains the model prediction' \
    --schedule='every 1 hours' \
    --replace=true \
        'select 
        period_id, 
        price_close, 
        price_open, 
        price_high, 
        price_low, 
        volume_traded, 
        trades_count, 
        tweets_count, 
        avg_neg_sentiment, 
        avg_pos_sentiment, 
        avg_compound_sentiment, 
        next_period_id, 
        next_period_price_close, 
        next_period_price_movement, 
        predicted_next_period_price_movement,
        (predicted_next_period_price_movement + price_close) as predicted_next_period_price_close
    from ML.PREDICT(MODEL `crypto_sentiment.bitcoin_model`,
    (
        select *
        from `crypto_sentiment.bitcoin_sentiments_consolidated`
    ));'