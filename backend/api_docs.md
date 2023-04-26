# API Documentation

ToDo : Shift Documentation to swagger

## Querying data

Method: POST (form-data)

Request Format:
`Array of sensors, array of users, start and end timestamp`
```
sensors[0]:1
sensors[1]:2
users[0]:3
users[1]:1
start:1564683717600
end:1564683719900
```
Response Format:
```
A Zip file (application/x-zip-compressed)
```

---

## Authentication

### Register
Method: POST

Request Format: 
```json
{
	"username": str,
	"password": str,
	"email": str,
	"first_name": str,
	"last_name": str,
	"properties": JSON
}
```
Response Format: 
```json
{
	"user": {
		"id": int,
		"username": str,
		"email": str,
		"first_name": str,
		"last_name": str,
		"properties": JSON },
	"token": str
}
```

### Login
Method: POST
Reqeust Format: 
```json
{
	"username": str,
	"password": str,
}
```
Response Format: (Example timestamp format given)
```json
{
	"expiry": "2022-12-06T17:09:13.747409",
	"token": str
}
```

## Logout
Method: POST
Reqeust Format: Include token in Authentication headers 
Response Format: TODO
```json
{
	
}
```