# This is a sample Python script.
import config
from sentientModel import Sentiment

import sentientModel
# Press ⌃R to execute it or replace it with your code.
# Press Double ⇧ to search everywhere for classes, files, tool windows, actions, and settings.


def print_hi(name):
    # Use a breakpoint in the code line below to debug your script.
    print(f'Hi, {name}')  # Press ⌘F8 to toggle the breakpoint.


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    print_hi('PyCharm')

#getHashtag.GetTweets.get_hashtag_search(config.QUERY, config.MAX_RESULTS)
Sentiment.compute_sentient_model(config.QUERY, config.MAX_RESULTS)

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
