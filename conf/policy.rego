package apisix.authz

# Default deny
default allow = false

# Allow if method is GET
#allow {
# input.request.method = "GET"
#}

# Allow if header x-api-key matches
allow {
  input.request.headers["x-api-key"] = "your-api-key"
}

# Allow if path starts with /allowed-path
#allow {
#  startswith(input.path, "/allowed-path")
#}

# OPA should return only one result with an allow field
allow_response = {
  "allow": allow
}