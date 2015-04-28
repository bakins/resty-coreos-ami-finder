# resty-coreos-ami-finder
Simple Openresty app for finding CoreOS AMI

This is a simple example app for finding the AMI for CoreOS for a
given AWS region.

See Dockerfile for example setup.  To run, do something like:
```
$ docker build -t resty-coreos-ami-finder .
$ docker run -p 8080:80 resty-coreos-ami-finder /opt/openresty/nginx/sbin/nginx -c /app/nginx.conf`
```

Example usage:

```
$ curl -sv http://<ip>:<port>/ami/alpha/sa-east-1
...
< HTTP/1.1 200 OK
* Server openresty/1.7.10.1 is not blacklisted
< Server: openresty/1.7.10.1
< Date: Tue, 28 Apr 2015 22:33:56 GMT
< Content-Type: application/json
< Connection: keep-alive
< Content-Length: 61
...
{
  "pv": "ami-3d3ebb20",
  "name": "sa-east-1",
  "hvm": "ami-033ebb1e"
}
```

Usage is `http://<host>:<port>/ami/<channel>/<region>
