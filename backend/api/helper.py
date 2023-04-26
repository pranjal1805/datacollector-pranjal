#Helper functions such as unix time to timestamp string format
import time
# import datetime
TIMESTAMP_FORMAT = str('%Y-%m-%d %H:%M:%S.%f')
# convert Unix time to timestamp
def nix_to_ts(unix_time):
	s, ms = divmod(unix_time, 1000)
	ts = '{}.{:03d}'.format(time.strftime('%Y-%m-%d %H:%M:%S', time.gmtime(s)), ms)
	# ts = datetime.datetime.strptime(ts, '%Y-%m-%d %H:%M:%S.%f')
	return ts
