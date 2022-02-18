import base64
import json
import os
from datetime import datetime

from google.cloud import pubsub_v1

# Instantiates a Pub/Sub client
publisher = pubsub_v1.PublisherClient()
PROJECT_ID = "crypto-sentiment-341504"

# topic to publish to 
topic_name = "coin-response"

# Publishes a message to a Cloud Pub/Sub topic.
def coin_request_from_api(event, context):

    # References an existing topic
    topic_path = publisher.topic_path(PROJECT_ID, topic_name)

    # Get 'data' from the pubsub event (dict)
    if 'data' in event:
        input_message = base64.b64decode(event['data']).decode('utf-8')
    else: 
        input_message = ""

    # Create a with the data from the Pub/Sub message 
    output_message_json = json.dumps({
            'message':input_message,
            'ingest_timestamp': str(context.timestamp)
    })

    output_message_bytes = output_message_json.encode('utf-8')
  
    print(f'Input message: {str(input_message)}')
    print(f'Publishing message to topic {topic_name}: {output_message_json}')

    # Publishes a message
    try:
        publish_future = publisher.publish(topic_path, data=output_message_bytes)
        publish_future.result()  # Verify the publish succeeded
        return 'Message published.'
    except Exception as e:
        print(e)
        return (e, 500)


