using GoogleMaps
using DarkSky
using HttpServer

http = HttpHandler() do req::Request, res::Response
    m = match(r"^/zipcode/\d{5}/?$",req.resource)
    if m == nothing return Response(404) end
    input = String(m.captures[1])
    response = geocode(input)
    latlng = response["results"][1]["geometry"]["location"]
    response = forecast(latlng["lat"], latlng["lng"]);
    return Response("$(currently(response))")
end

server = Server( http )
run( server, 8000 )
