import base64
import json
import os
from datetime import datetime

from google.cloud import pubsub_v1


# Instantiates a Pub/Sub client
publisher = pubsub_v1.PublisherClient()
PROJECT_ID = "crypto-sentiment-341504"

# topic to publish to 
topic_name = "twitter-response"



# Publishes a message to a Cloud Pub/Sub topic.
def twitter_request_from_api(event, context):

    print(f'Publishing message to topic {topic_name}')

    # References an existing topic
    topic_path = publisher.topic_path(PROJECT_ID, topic_name)

    # Get 'data' from the event (dict)
    if 'data' in event:
        message = base64.b64decode(event['data']).decode('utf-8')
    else: 
        message = ""

    # Create a with the data from the Pub/Sub message 
    message_json = json.dumps({
       # 'data': {
            'message':message,
            'ingest_timestamp': str(context.timestamp)
        #}
    })

    #message_json = {'message': message}

    message_bytes = message_json.encode('utf-8')

    # Publishes a message
    try:
        publish_future = publisher.publish(topic_path, data=message_bytes)
        publish_future.result()  # Verify the publish succeeded
        return 'Message published.'
    except Exception as e:
        print(e)
        return (e, 500)


