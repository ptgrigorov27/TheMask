# Gabrielle Stoney, Marc Meier-Dornberg
import base64
#from distutils.command.config import config
import json
import os
import tweepy
from google.cloud import bigquery
from datetime import datetime
from config import ConfigClass
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer

# Prepare the BigQuery Client
PROJECT_ID = "crypto-sentiment-341504"
BQ_DATASET = "crypto_sentiment"
BQ_TABLE = "tweets_prepared"
BQ = bigquery.Client()

# twitter query parameters
max_results = 11
query = '#bitcoin'

# Publishes a message to a Cloud Pub/Sub topic.
def twitter_request_from_api(event, context):

    # get current timestamp so that all messages of this mini-batch are of the same timestamp
    current_timestamp = str(context.timestamp)

    client = ConfigClass.get_client()
    twitter_search_dict = client.search_recent_tweets(query,
                                                          user_auth=False,
                                                          expansions=['author_id', 'referenced_tweets.id',
                                                                      'geo.place_id'],
                                                          tweet_fields=['created_at', 'conversation_id', 'lang',
                                                                        'in_reply_to_user_id', 'geo', 'public_metrics'],
                                                          max_results=max_results)
    
    if not twitter_search_dict.data is None and len(twitter_search_dict.data) > 0:
        for tweet in twitter_search_dict.data:
            # Get Twitter Data from Twitter Object
            tweet_user_id = {}
            tweet_user_id['id'] = tweet.id
            tweet_user_id['text'] = tweet.text
            tweet_user_id['author_id'] = tweet.author_id
            tweet_user_id['conversation_id'] = tweet.conversation_id
            tweet_user_id['created_at'] = str(tweet.created_at)
            tweet_user_id['place_id'] = tweet.geo
            tweet_user_id['in_reply_to_user_id'] = tweet.in_reply_to_user_id
            tweet_user_id['lang'] = tweet.lang
            for metric in tweet.public_metrics:
                if metric == 'reply_count':
                    tweet_user_id['reply_count'] = tweet.public_metrics['reply_count']
                if metric == 'like_count':
                    tweet_user_id['like_count'] = tweet.public_metrics['like_count']
                if metric == 'retweet_count':
                    tweet_user_id['retweet_count'] = tweet.public_metrics['retweet_count']
                if metric == 'quote_tweet':
                    tweet_user_id['quote_tweet'] = tweet.public_metrics['quote_count']

            # Get sentient value of each tweet
            analyzer = SentimentIntensityAnalyzer()
            sentient_dict = analyzer.polarity_scores(tweet.text)

            # Put sentient score in tweet dictionary
            for score in sentient_dict:
                if score == 'pos':
                    tweet_user_id['pos_Sentiment'] = sentient_dict['pos']
                if score == 'neg':
                    tweet_user_id['neg_Sentiment'] = sentient_dict['neg']
                if score == 'Neu':
                    tweet_user_id['new_Sentiment'] = sentient_dict['neu']
                if score == 'compound':
                    tweet_user_id['compound_Sentiment'] = sentient_dict['compound']
            tweet_user_id['ingest_timestamp'] = current_timestamp

            # Publishes a message
            try:
                insert_into_bigquery(tweet_user_id)
            except Exception as e:
                print(e)
                return (e, 500)

def insert_into_bigquery(mydict):
    table = BQ.dataset(BQ_DATASET).table(BQ_TABLE)
    errors = BQ.insert_rows_json(table,
                                 json_rows=[mydict])
    if errors != []:
        raise BigQueryError(errors)

class BigQueryError(Exception):
    '''Exception raised whenever a BigQuery error happened''' 
    def __init__(self, errors):
        super().__init__(self._format(errors))
        self.errors = errors

    def _format(self, errors):
        err = []
        for error in errors:
            err.extend(error['errors'])
        return json.dumps(err)
