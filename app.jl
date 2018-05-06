using GoogleMaps
using DarkSky
using HttpServer
using JSON

function get_latlng(x::Dict)
    latlng = x["results"][1]["geometry"]["location"];
    return (latlng["lat"], latlng["lng"])
end

http = HttpHandler() do req::Request, res::Response
    m = match(r"^/zipcode/(\d+)/?$", req.resource)
    if m == nothing return Response(404) end
    input = String(m.captures[1]);
    location = geocode(input);
    (lat, lng) = get_latlng(location);
    weather = forecast(lat, lng);
    d = Dict()
    for f in fieldnames(weather)
        d[f] = getfield(weather, f)
    end
    response = Dict("location" => location, "weather" => d)
    resp = Response(JSON.json(response))
    resp.headers["Content-Type"] = "application/json"
    return resp
end
http.events["error"]  = (client, err) -> println(err)
http.events["listen"] = (port)        -> println("Listening on $port...")

server = Server( http )
run( server, 8000 )
