from config import ConfigClass


class GetTweets():
    def __init__(self):
        self.self = self

    @staticmethod
    def get_hashtag_search(query, max_results):
        client = ConfigClass.get_client()
        twitter_search_dict = client.search_recent_tweets(query,
                                                          user_auth=False,
                                                          expansions=['author_id', 'referenced_tweets.id',
                                                                      'geo.place_id'],
                                                          tweet_fields=['created_at', 'conversation_id', 'lang',
                                                                        'in_reply_to_user_id', 'geo', 'public_metrics'],
                                                          max_results=max_results)
        results = []
        if not twitter_search_dict.data is None and len(twitter_search_dict.data) > 0:
            for tweet in twitter_search_dict.data:
                tweet_user_id = {}
                tweet_user_id['text'] = tweet.text
                tweet_user_id['author_id'] = tweet.author_id
                tweet_user_id['conversation_id'] = tweet.conversation_id
                tweet_user_id['created_at'] = tweet.created_at
                # tweet_user_id['latitude_coordinates'] = tweet.latitude_coordinate
                # tweet_user_id['longitude_coordinate'] = tweet.longitude_coordinate
                tweet_user_id['place_id'] = tweet.geo
                tweet_user_id['in_reply_to_user_id'] = tweet.in_reply_to_user_id
                tweet_user_id['lang'] = tweet.lang
                # tweet_user_id['impression_count'] = tweet.impression_count
                for metric in tweet.public_metrics:
                    if metric == 'reply_count':
                        tweet_user_id['reply_count'] = tweet.public_metrics['reply_count']
                    if metric == 'like_count':
                        tweet_user_id['like_count'] = tweet.public_metrics['like_count']
                    if metric == 'retweet_count':
                        tweet_user_id['retweet_count'] = tweet.public_metrics['retweet_count']
                    if metric == 'quote_tweet':
                        tweet_user_id['quote_tweet'] = tweet.public_metrics['quote_count']
                results.append(tweet_user_id)
            return results
        '''for result in results:
            print(result)'''
