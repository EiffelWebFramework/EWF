Filter example

To test the example, you can just run in a terminal:
> curl -u foo:bar http://localhost:9090/user/1 -v

Trying to access another user that the authenticated one, which is forbidden in this example:
> curl -u foo:bar http://localhost:9090/user/2 -v
