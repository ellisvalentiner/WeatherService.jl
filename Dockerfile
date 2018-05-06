FROM julia:0.6.2

RUN apt-get update && \
    apt-get install -y \
        libhttp-parser-dev \
        node \
        npm \
        unzip
RUN julia -e 'Pkg.clone("git://github.com/ellisvalentiner/GoogleMaps.jl.git");'
RUN julia -e 'Pkg.clone("git://github.com/ellisvalentiner/DarkSky.jl.git");'
RUN julia -e 'Pkg.add("HttpServer");'
RUN julia -e 'Pkg.build("HttpParser");'

ADD app.jl app.jl

EXPOSE 8000

CMD ["julia", "app.jl"]
