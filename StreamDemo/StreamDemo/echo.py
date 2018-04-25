# Simple echo server

import socket

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
s.bind(('0.0.0.0', 12345))
s.listen(1)

connection, address = s.accept()
print 'Connected by', address

while True:
    data = connection.recv(1024)
    print data
    if not data: break
    connection.sendall(data)

connection.shutdown(1)
connection.close()
