# no working
curl -i -X GET http://localhost:9080/index.html 

# working
curl -i -X GET http://localhost:9080/index.html -H "apikey: example-key"

