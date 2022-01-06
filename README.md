# docker-mozart

## Run a .oz file
Simply create a Dockerfile with the following:
```Dockerfile
FROM mass301/mozart:latest

ADD yourapp.oz .
RUN ozc -c yourapp.oz
CMD ["ozengine", "yourapp.ozf"]
```
