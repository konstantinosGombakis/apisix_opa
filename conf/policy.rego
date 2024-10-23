package apisix.authz

default allow = {"result": false}

allow = {"result": true} {
    input.request.headers["x-auth"]
}
