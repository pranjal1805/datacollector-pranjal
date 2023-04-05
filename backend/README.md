# Backend for mHealth Applications.
<img alt="Python" src="https://img.shields.io/badge/python-%2314354C.svg?style=for-the-badge&logo=python&logoColor=white"/> <img alt="Django" src="https://img.shields.io/badge/django-%23092E20.svg?style=for-the-badge&logo=django&logoColor=white"/> 

## About
- APIs for stroring and querying of sensor data. Written in Django and Django REST Framework.
- Database Used: psql with timescaledb extn.
- maintener and author @tanmay-rpatil
- project mentor @senigmatic
- API Docs: [api_docs](/backend/api_docs.md)

## Database
 
- Postgresql version 13
- TimescaleDB version 2.4.0 

```sql
 -- SQL query to check the timescaledb version is - 
 SELECT extversion
 FROM pg_extension
 where extname = 'timescaledb';
```

## Directory Structure
- ``` accounts/ ``` : Django app defining custom user model, and authentication APIs
- ``` api/ ``` : Django app defining all models and providing the api interface
- ``` backend/ ``` : Django settings, conf directory
- ``` database_design/ ``` : Documentation for the database schema. 
- ``` testing/ ``` : Scripts to test the APIs
- ``` media/ ``` : Temperory - location to store media files 

## TODO
- Query format for multiple users, multiple sensors, and multiple annotations
- **IMP -> HANDLE ERROR CONDITIONS** such as invalid serializers
- Add docs for production ref(https://www.digitalocean.com/community/tutorials/how-to-set-up-django-with-postgres-nginx-and-gunicorn-on-ubuntu-18-04)
- Improve Documentation
- Beutify script dump below
