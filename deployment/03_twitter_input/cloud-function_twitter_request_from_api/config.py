import tweepy

class ConfigClass():

    @staticmethod
    def get_client():
        client = tweepy.Client(bearer_token=BEARER_KEY,
                               consumer_key=API_KEY,
                               consumer_secret=API_SECRET_KEY,
                               access_token=ACCESS_TOKEN,
                               access_token_secret=ACCESS_TOKEN_SECRET)
        return client


# Consumer keys
API_KEY = 't0EHXPHPTkrcIaE8zXkX8WPC1'
API_SECRET_KEY = 'BTHDFoVPtHnnsKal4FyzMRJxv8Wuw87TrhnopCXQQHbKTZ5twM'

# Authentication keys
BEARER_KEY = 'AAAAAAAAAAAAAAAAAAAAAIedYwEAAAAAJ8krpnhXYxamTw9Vz3P9jLvsrHY%3DfXdUdYeRScPV6pOubGE1GcnVk3HZQmnl2HqMJCwdC9ng9GnIxE'
ACCESS_TOKEN = '2713500069-FsqRpyq72DV1LEI2VjzXGqQ3MfSGbq1UkdEG3qB'
ACCESS_TOKEN_SECRET = 'ZOPvYFI2SSnmEG6M2UuTkMw5pWtCpa5QtC651VMAjp6LM'

# Authorization 2.0 Client ID & Secret keys
CLIENT_ID = 'YjdUQlRudjJFeVJseFFmZDJMbk06MTpjaQ'
CLIENT_ID_SECRET = 'FOpifsHcRpMjKKgNnVohN3V8IoMJwxRQYAhHe8vEIyaEC7ldME'

