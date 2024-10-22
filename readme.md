# no working
curl -i -X GET http://localhost:9080
curl -i -X GET http://localhost:9080/secure.htm 

# working
curl -i -X GET http://localhost:9080 -H "apikey: example-key"
curl -i -X GET http://localhost:9080/secure.htm -H "apikey: example-key"



