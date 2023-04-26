import csv,json,requests
from typing import OrderedDict 
from time import sleep
# max_row = [10,50,100,500,1000,5000,10000]

# lowspec server
api_url = 'www.mhealthbackend.live/api/insert'

def testHelper(request_body):
	r = requests.post(url=api_url, json=request_body)
	return r
