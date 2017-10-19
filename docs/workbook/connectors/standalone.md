Nav: [Workbook](../workbook.md)

## The EiffelWeb standalone connector

It provides a standalone httpd server for the EiffelWeb framework.
It implements HTTP/1.1 with persistent connection, concurrent connection, ...

To easily set the standalone connector, see class `WSF_STANDALONE_SERVICE_OPTIONS`.

### Main settings:

* `port`: Listening port number (defaut: 80).
* `max_concurrent_connections`: maximum of concurrent connections (default: 100)
* `max_tcp_clients`: Listen on socket for at most `max_tcp_clients` connections (default: 100)
* `socket_timeout`: Amount of seconds the server waits for receipts and transmissions during communications. With timeout of 0, socket can wait for ever. (default: 60)
* `socket_recv_timeout`: Amount of seconds the server waits for receiving data during communications. With timeout of 0, socket can waits for ever. (default: 5)
* `keep_alive_timeout`: Persistent connection timeout. Number of seconds the server waits after a request has been served before it closes the connection (default: 5)
* `max_keep_alive_requests`: Maximum number of requests allowed per persistent connection. To disable KeepAlive, set `max_keep_alive_requests` to `0`. To have no limit, set `max_keep_alive_requests` to `-1` (default: 300).

* `is_secure`: check SSL certificate?
* `secure_certificate`: path to SSL certificate.
* `secure_certificate_key`: certificate key

* `verbose`: display verbose output (Default: false)

See also `WGI_STANDALONE_CONSTANTS` for default values.

