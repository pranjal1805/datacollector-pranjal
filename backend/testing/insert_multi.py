from test_insertions import testHelper
from time import sleep
import csv,json,requests
from typing import OrderedDict 
max_row = []
sum = 0
for i in range(21):
	sum += 1000*(i+1)
	max_row.append(1000*(i+1))
print(sum)

# lowspec server
api_url = 'www.mhealthbackend.live/api/insert'

with open('./Sample_Data/accel-converted.csv') as csvfile:
	reader = csv.DictReader(csvfile)
	for count in max_row:
		request_body = OrderedDict()
		data = []
		i = 0
		for row in reader:
			data.append(row)
			i += 1
			if(i>=count):
				break
		request_body['sensor_id'] = 1
		request_body['data'] = data
		request_body['count'] = count
		print(count)
		testHelper(request_body)
		sleep(0.5)