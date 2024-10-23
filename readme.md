Testing the integration of OPA and APISIX

run: ```docker compose up```

OPA rules -> conf/policy.rego

APISIX in standalone mode (no needed etcd)->conf/apisix.yaml

# Not authorized
```bash
curl -i -X GET http://localhost:9080
```
```bash
curl -i -X GET http://localhost:9080/secure.html 
```
```bash
curl -i -X GET http://localhost:9080/secure.html  -H "x-api-key: your-api-key1"
```

# working
```bash
curl -i -X GET http://localhost:9080 -H "x-api-key: your-api-key"
```
```bash
curl -i -X GET http://localhost:9080/secure.html  -H "x-api-key: your-api-key"
```

# Creation routes for OPA and apisix
from conf/policy.rego-> package apisix.authz

we create a endpoint /v1/data/apisix/authz for apisix to send the request to get the policy output (true/false)

We set on conf/apisix.yaml the endpoint-> policy: "apisix/authz"


## apisix to opa
apisix create the following json for the opa to check:

So we need to set the opa rules according to the json ie input.request.headers to get the headers array

```json
{
    "client_addr": "192.168.128.4:54698",
    "level": "info",
    "msg": "Received request.",
    "req_body": {
        "input": {
            "var": {
                "server_addr": "192.168.128.4",
                "remote_addr": "192.168.128.1",
                "timestamp": 1729678297,
                "remote_port": "59222",
                "server_port": "9080"
            },
            "type": "http",
            "request": {
                "headers": {
                    "user-agent": "curl/7.88.1",
                    "host": "localhost: 9080",
                    "accept": "*/*"
                },
                "query": {},
                "port": 9080,
                "path": "/secure.html",
                "scheme": "http",
                "host": "localhost",
                "method": "GET"
            }
        }
    },
    "req_id": 8,
    "req_method": "POST",
    "req_params": {},
    "req_path": "/v1/data/apisix/authz",
    "time": "2024-10-23T10: 11: 37Z"
}
```
### opa response
### not allowed
```json
{
  "client_addr": "192.168.128.4:54698",
  "level": "info",
  "msg": "Sent response.",
  "req_id": 8,
  "req_method": "POST",
  "req_path": "/v1/data/apisix/authz",
  "resp_body": {
    "result": {
      "allow": **false**,
      "allow_response": {
        "allow": **false**
      }
    }
  },
  "resp_bytes": 60,
  "resp_duration": 0.948896,
  "resp_status": 200,
  "time": "2024-10-23T10:11:37Z"
}
```
### allowed
```json
{
  "client_addr": "192.168.128.4:54698",
  "level": "info",
  "msg": "Sent response.",
  "req_id": 8,
  "req_method": "POST",
  "req_path": "/v1/data/apisix/authz",
  "resp_body": {
    "result": {
      "allow": **true**,
      "allow_response": {
        "allow": **true**
      }
    }
  },
  "resp_bytes": 60,
  "resp_duration": 0.948896,
  "resp_status": 200,
  "time": "2024-10-23T10:11:37Z"
}
```