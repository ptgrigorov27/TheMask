# Create the table bitcoin_sentiments_consolidated from bitcoin_ohlcv and tweets_filtered
# The table bitcoin_sentiments_consolidated aggregates the data from the two bitcoin_ohlcv and tweets_filtered
# The query run every hour and rewrite the table
# Marc Meier-Dornberg
bq query \
    --use_legacy_sql=false \
    --destination_table=crypto_sentiment.bitcoin_sentiments_consolidated \
    --display_name='Scheduled Query to overwrite bitcoin_sentiments_consolidated every hour' \
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
        TIMESTAMP_ADD(period_id, INTERVAL 1 hour) as next_period_id, 
        lead(price_close, 1) over (order by period_id) as next_period_price_close, 
        (lead(price_close, 1) over (order by period_id) - price_close) as next_period_price_movement
    from (
        select 
            ohlcv.period_id as period_id,
            avg(subselect_price_close.sub_price_close) as price_close, 
            avg(subselect_price_open.sub_price_open) as price_open, 
            max(price_high) as price_high, 
            min(price_low) as price_low, 
            sum(volume_traded) as volume_traded, 
            sum(trades_count) as trades_count, 
            count(subselect_tweets.text) as tweets_count, 
            avg(subselect_tweets.pos_Sentiment) as avg_pos_sentiment, 
            avg(subselect_tweets.neg_Sentiment) as avg_neg_sentiment, 
            avg(subselect_tweets.compound_sentiment) as avg_compound_sentiment
        from ( 
            select     
                DATETIME_TRUNC(time_close, HOUR) as period_id, 
                *
            from 
                `crypto-sentiment-341504.crypto_sentiment.bitcoin_ohlcv`
        ) as ohlcv inner join (
            SELECT 
                DATETIME_TRUNC(time_close, HOUR) as period_id, 
                RANK() OVER ( PARTITION BY  DATETIME_TRUNC(time_close, HOUR) ORDER BY time_close desc) AS rank_time_close, 
                price_close as sub_price_close
            FROM 
                `crypto-sentiment-341504.crypto_sentiment.bitcoin_ohlcv` 
        ) as subselect_price_close on ohlcv.period_id = subselect_price_close.period_id 
        inner join (
            SELECT 
                DATETIME_TRUNC(time_close, HOUR) as period_id, 
                RANK() OVER ( PARTITION BY  DATETIME_TRUNC(time_close, HOUR) ORDER BY time_close asc) AS rank_time_close, 
                price_open as sub_price_open
            FROM 
                `crypto-sentiment-341504.crypto_sentiment.bitcoin_ohlcv` 
        ) as subselect_price_open on subselect_price_close.period_id = subselect_price_open.period_id 
        left join(
            select 
                DATETIME_TRUNC(created_at, HOUR) as period_id, 
                *
            from
                `crypto-sentiment-341504.crypto_sentiment.tweets_filtered` 
        ) as subselect_tweets ON ohlcv.period_id = subselect_tweets.period_id 
        where 
            subselect_price_close.rank_time_close = 1 and 
            subselect_price_open.rank_time_close = 1 
        group by 
            ohlcv.period_id
    ) 
    order by period_id desc'


