# script to retirve at max n minutes of data from a csv
import time,csv

# convert Unix time to timestamp
def nix_to_ts(unix_time):
	s, ms = divmod(unix_time, 1000)
	timestamp = '{}.000{:03d}'.format(time.strftime('%Y-%m-%d %H:%M:%S', time.gmtime(s)), ms)
	return timestamp

#select rows from the csv within a certain timespan
n  = 15 # min
MS_IN_MIN = 60000 #ms in a minute = 60*100

with open('./Sample_Data/gyro.csv') as csvfile:
	reader = csv.reader(csvfile)
	with open('./Sample_Data/gyro-short.csv','w') as opfile:
		writer = csv.writer(opfile)
		i=0
		max_ts = n*MS_IN_MIN
		for row in reader:
			if i==0:
				i=1
				old_ts = int(row[0])
				max_ts += int(row[0])
				writer.writerow(row)
				continue
			elif (int(row[0]))<=max_ts:
				# ts = (nix_to_ts(int(row[0])))
				# row[0] = ts
				writer.writerow(row)
			else:
				# print(max_ts,row[0],n*MS_IN_MIN, int(row[0])-old_ts)    
				break
				