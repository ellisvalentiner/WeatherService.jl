using GoogleMaps
using DarkSky
using HttpServer
using HttpCommon
using JSON

http = HttpHandler() do req::Request, res::Response
    m = match(r"^/zipcode/(\d+)/?$",req.resource)
    if m == nothing return Response(404) end
    input = String(m.captures[1]);
    response = geocode(input);
    latlng = response["results"][1]["geometry"]["location"];
    response = forecast(latlng["lat"], latlng["lng"]);
    x = JSON.json(response.currently)
    resp = Response(x)
    resp.headers["Content-Type"] = "application/json"
    return resp
end
http.events["error"]  = (client, err) -> println(err)
http.events["listen"] = (port)        -> println("Listening on $port...")

server = Server( http )
run( server, 8000 )
