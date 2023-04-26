# Server Setup
This document contains instructions to setup a development server on Ubuntu based systems. Can ideally work on any of Linux, Mac or Windows. Installation steps may vary,but the setup is similar. 
 
So far tested only on Debian and Ubuntu.

Reccomeded: Ubuntu 22.04 or higher for up to date packages. Loweset Ubuntu release tested on: 18.04.

## NOTE - Custom python version NOT needed if python version>=3.10.x is installed/available in the repos 

# 1. Packages to Install

## Install Custom Python Version (Python 3.10.x)
Uses a 3rd party PPA. Not suggested if Ubuntu is 22.x.x or greater, as the pre-installed python version is 3.10.x or greater.

Another option is (a lot more tedious) building from source.
```bash
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.10
```

## IMP NOTES regarding custom python version:

If you have a custom python install, in the following python commands, you should replace `python3` with `python3.x` , `python3.10` as of now.

If using Ubuntu provided `python3` , then all commands can be run as it is. 

## Pip3, Python venv install
```bash
# if using the custom python version from deadsnakes ppa, ONLY venv is required.
$ sudo apt install python3.10-venv
# if using local default python version
$ sudo apt install python3-venv
$ sudo apt install python3-pip
```

# NOTE: Ensure that psql and timescale db are the same version (eg. postgreql-14 and timscaledb-2-posgresql-14)

## Postgresql install
Refer [Psql-docs](https://www.postgresql.org/download/linux/ubuntu/)
```bash
$ sudo apt update
$ sudo apt -y install gnupg2
$ wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

$ echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" |sudo tee  /etc/apt/sources.list.d/pgdg.list
 
$ sudo apt update
$ sudo apt -y install postgresql-14 postgresql-client-14
$ sudo pg_ctlcluster 14 main status
```

## TimescaleDB setup
Refer [Timescale-docs](https://docs.timescale.com/install/latest/self-hosted/installation-debian/) 
Make sure the commands correspond to your OS(debain or ubuntu)
```bash
$ sudo apt install gnupg postgresql-common apt-transport-https lsb-release wget
$ sudo sh /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh

$ sudo sh -c "echo 'deb https://packagecloud.io/timescale/timescaledb/ubuntu/ $(lsb_release -c -s) main' | sudo tee /etc/apt/sources.list.d/timescaledb.list"
$ wget --quiet -O - https://packagecloud.io/timescale/timescaledb/gpgkey | sudo apt-key add -
$ sudo apt update
$ sudo apt install timescaledb-2-postgresql-14
 
$ sudo timescaledb-tune --quiet --yes
# Restart PostgreSQL instance
$ sudo service postgresql restart
```
---
# 2. Configure Database

## psql setup
```
$ sudo su - postgres
$ psql
    postgres=# ALTER USER postgres PASSWORD 'psswd_here';
    ALTER ROLE
    postgres=# \q
$ sudo psql -U postgres -h localhost
    postgres=# CREATE database backend;
    postgres=# CREATE EXTENSION IF NOT EXISTS timescaledb;
    postgres=# \q
```
---
# 3. Configure Django, setup a dev server.

## Setup django
```bash
$ git clone "{repo_url}"
$ cd ./backend
#### optional
# Strongly suggested in a dev environment,or specially when using a custom python version. Replace with python3.x as reccomended in above notes
$ python3 -m venv env  
$ source ./env/bin/activate
### 
$ pip install -r ./requirements.txt
```

## Configuration files for our application.
Secret key and DB password are set in the following files. Create the directory and files if they don't exist.
```
backend
├── config_files
│   ├── key.txt
│   └── pswd.txt
```

```bash
$ cd ./config_files
$ echo $(cat /dev/urandom | LC_ALL=C tr -dc '[:alpha:]'| fold -w 50 | head -n1) > key.txt
$ echo "your_psql_password_here" > pswd.txt
```

Now create the database schema using
```bash
$ python3 manage.py makemigrations
$ python3 manage.py migrate
```

Create an admin user for our application, and test the dev server!
```bash
$ python manage.py createsuperuser
# Create an account. Note that this is the admin user for our admin portal.
$ python manage.py runserver 
# A dev server should be up and runnig! 🎉🎉
```
---
# 4. Setup deplyment using Nginx
 TODO! 
## Disable apache or any other application using port 80

    sudo update-rc.d apache2 disable
    sudo /etc/init.d/apache2 stop
    sudo /home/f20190054/backend/env/bin/python /home/f20190054/backend/manage.py  runserver 0.0.0.0:80

## For setting up cronjob to start server at reboot

    crontab -e
        #insert the following line 
        @reboot /home/f20190054/backend/env/bin/python /home/f20190054/backend/manage.py  runserver 0.0.0.0:80

## Using production server - TODO

NGINX -> 
    sudo nano /etc/nginx/nginx.conf
    insidehttp{}, add:
    client_max_body_size 100M;

# 5. Troubleshooting
TODO !
## For truncating a table

    sudo psql -U postgres -h localhost
        postgres=# \c backend
        backend=# TRUNCATE api_sensor_reading;

