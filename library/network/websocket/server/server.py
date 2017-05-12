#!/usr/bin/env python

import socket, threading, time, re, hashlib, base64

magicguid = "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"
port = 9999


def printHeaders(headers):
    print "Headers received from WebSocket client"
    for key in headers.keys():
        print key, headers[key]
    print


def doHandShake(conn, dataheaders):
    headers = dict(re.findall(r"(?P<name>.*?): (?P<value>.*?)\r\n", dataheaders))
    printHeaders(headers)
    key = headers['Sec-WebSocket-Key']
    print "key", key
    key += magicguid
    hashkey = hashlib.sha1()
    hashkey.update(key)
    key = base64.b64encode(hashkey.digest())
    handshake = "HTTP/1.1 101 Switching Protocols\r\n"
    handshake += "Upgrade: websocket\r\n"
    handshake += "Connection: Upgrade\r\n"
    handshake += "Sec-WebSocket-Accept: " + key + "\r\n"
    # end of header empty line
    handshake += "\r\n"
    print
    print handshake
    conn.send(handshake)


def handle(conn):
    time.sleep(1)
    conn.send('\x81\x0BHello World')
    time.sleep(1)
    conn.send('\x81\x12How are you there?')
    time.sleep(1)
    conn.close()


s = socket.socket()
s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
s.bind(('127.0.0.1', port))
print "Server listening on port", port
s.listen(1)
while 1:
    try:
        conn, address = s.accept()
        dataheaders = conn.recv(4096)
        doHandShake(conn, dataheaders)
        print "WebSocket open"
        threading.Thread(target=handle, args=(conn,)).start()
    except KeyboardInterrupt:
        print
        print "Closing now"
        exit(0)
