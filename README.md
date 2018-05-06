# WeatherService.jl

Web service to accept a zipcode and return geocoding and forecast data, using the Google Maps and Dark Sky APIs.

To start the service:

```sh
$ julia app.jl
```

or using Docker:

```sh
docker build -t weatherservice .
docker run -p 8000:8000 -e DARKSKY_API_KEY=XXXXX -e GOOGLE_MAPS_KEY=XXXXX weatherservice
```

To make a request:

```sh
$ curl localhost:8000/zipcode/48108
```
