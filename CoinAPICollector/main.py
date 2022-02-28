#from coinapi_rest_v1.restapi import CoinAPIv1
from http.client import TOO_MANY_REQUESTS
from operator import truediv
from pickle import TRUE
from socket import timeout
from requests import Request, Session
from requests.exceptions import ConnectionError, Timeout
import json

symbold_id = 'BITSTAMP_SPOT_BTC_USD'
period_id = '1MIN'

url = f'https://rest.coinapi.io/v1/ohlcv/{symbold_id}/latest?period_id={period_id}'
headers = {'X-CoinAPI-Key' : '2A456E48-0916-4AA8-AA30-9759E6BE3186'}


#url ='/v1/ohlcv/{symbol_id}/history?period_id={period_id}&time_start={time_start}&time_end={time_end}&limit={limit}&include_empty_items={include_empty_items}'

coin_parameters = {

    'symbol_id' : symbold_id,
    'limit' : 16,
    'include_empty_items' : TRUE,
    'period_id' : period_id,

}
# BAISICALLY REQUESTING INFORMATION - access to page or not?

session = Session()
session.headers.update(headers)


try:
    response = session.get(url, params=coin_parameters)
    coin_api = json.loads(response.text)[1:]
    for element in coin_api:
        print(element)
        print("")
except (ConnectionError, timeout) as e:
    print(e)