import base64
import json
import os
from datetime import datetime
from http.client import TOO_MANY_REQUESTS
from operator import truediv
from pickle import TRUE
from socket import timeout
from requests import Request, Session
from requests.exceptions import ConnectionError, Timeout
from google.cloud import pubsub_v1


# Instantiates a Pub/Sub client
publisher = pubsub_v1.PublisherClient()
PROJECT_ID = "crypto-sentiment-341504"

# topic to publish to 
topic_name = "coin-to-bq"

# API requests parameters
symbold_id = 'BITSTAMP_SPOT_BTC_USD'
period_id = '1MIN'
url = f'https://rest.coinapi.io/v1/ohlcv/{symbold_id}/latest?period_id={period_id}'
headers = {'X-CoinAPI-Key' : '2A456E48-0916-4AA8-AA30-9759E6BE3186'}

coin_parameters = {

    'symbol_id' : symbold_id,
    'limit' : 16,
    'include_empty_items' : TRUE,
    'period_id' : period_id,

}

# Publishes a message to a Cloud Pub/Sub topic.
def coin_request_from_api(event, context):

    # References an existing topic
    topic_path = publisher.topic_path(PROJECT_ID, topic_name)

    # get current timestamp so that all messages of this mini-batch are of the same timestamp
    current_timestamp = str(context.timestamp)

    session = Session()
    session.headers.update(headers)

    response_dict_list = []

    try:
        response = session.get(url, params=coin_parameters)
        # generate a dict list of the 16 responses
        # ignore the last period as it is usually only a part of the full period
        response_dict_list = json.loads(response.text)[1:]  
    except (ConnectionError, timeout) as e:
        print(e)

    for response_dict in response_dict_list: 
        response_dict['ingest_timestamp'] = current_timestamp
        output_message_json = json.dumps(response_dict)

        output_message_bytes = output_message_json.encode('utf-8')
    
        print(f'Input message: {str(output_message_json)}')
        print(f'Publishing message to topic {topic_name}: {output_message_json}')

        # Publishes a message
        try:
            publish_future = publisher.publish(topic_path, data=output_message_bytes)
            publish_future.result()  # Verify the publish succeeded
        except Exception as e:
            print(e)
            return (e, 500)


