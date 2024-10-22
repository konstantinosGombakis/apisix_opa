package apisix.authz

default allow = false

allow {
    input.request.headers["x-auth"]
}
