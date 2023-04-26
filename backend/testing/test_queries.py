import requests, time

# convert Unix time to timestamp IMP-> Assuming timestamp with ms
def nix_to_ts(unix_time):
	s, ms = divmod(unix_time, 1000) #splits time into s and ms
	timestamp = '{}.{:3d}'.format(time.strftime('%Y-%m-%d %H:%M:%S', time.gmtime(s)), ms) #gets a timestamp in the format %Y-%m-%d %H:%M:%S.%ms
	print(type(timestamp))
	return timestamp

url = "http://127.0.0.1:8000/api/upload_readings/"
base_ts = 1564682618725
JMP = 15*60*1000 # num of ms in 15 min
for i in range(1): # num of 15 min chunks in a day
	payload={
		'sensor': '1',
		'time': nix_to_ts(base_ts)
	}
	files=[
		('data_file',('gyro-short.csv',open('./Sample_Data/gyro-short.csv','rb'),'text/csv'))
	]
	response = requests.request("POST", url, data=payload, files=files)
	base_ts+=JMP
	print(response.text)

print(nix_to_ts(1564682618725))
