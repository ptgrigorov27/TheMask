
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer

from getHashtag import GetTweets
from getHashtag import GetTweets
import config


class Sentiment:
    @staticmethod
    def compute_sentient_model(query, max_result):
        analyzer = SentimentIntensityAnalyzer()
        resultant_tweets = GetTweets.get_hashtag_search(config.QUERY, config.MAX_RESULTS)

        for tweets in range(len(resultant_tweets)):
            tweet_dict = resultant_tweets[tweets]['text']
            sentient_dict = analyzer.polarity_scores(tweet_dict)

            for score in sentient_dict:
                if score == 'pos':
                    resultant_tweets[tweets]['Pos_Sentiment'] = sentient_dict['pos']
                if score == 'neg':
                    resultant_tweets[tweets]['Neg_Sentiment'] = sentient_dict['neg']
                if score == 'Neu':
                    resultant_tweets[tweets]['New_Sentiment'] = sentient_dict['neu']
                if score == 'compound':
                    resultant_tweets[tweets]['Compound_Sentiment'] = sentient_dict['compound']
                    