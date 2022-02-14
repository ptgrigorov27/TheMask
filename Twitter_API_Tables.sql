#create database
create database twitter_api;
use twitter_api;

#create table for Parsed Tweets w/ Sentiment Score
create table parse_tweet_sent (ID varchar(255), Tweet_text varchar(255),
author_id varchar(255), conversation_id varchar(255), 
create_at datetime, latitude_coords decimal(10,8), 
longitude_coords decimal(10,8), place_id varchar(255),
in_reply_to_user_id varchar(255), lang varchar(255),
impression_count int, retweet_count int, reply_count int,
like_count int, quote_count int, received_tms timestamp,
sentiment varchar(255));

#create table for Parsed CoinAPI responses
create table parse_coin (asset_id_base varchar(10),
time_ datetime, asset_id_quote varchar(10), rate decimal(10,10));

show tables;