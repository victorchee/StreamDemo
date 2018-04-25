# Simple echo server

import socket

def listen():
	connection = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	connection.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
	connection.bind(('0.0.0.0', 12345))
	connection.listen(10)
	while True:
		currentConnection, address = connection.accept()
		print 'received message'
		while True:
			data = currentConnection.recv(2048)
			if data == 'quit\r\n':
				currentConnection.shutdown(1)
				currentConnection.close()
				break
			elif data == 'stop\r\n':
				currentConnection.shudown(1)
				currentConnection.close()
				exit()
			elif data:
				currentConnection.send(data)
				print data

if __name__ == "__main__":
	try:
		listen()
	except KeyboardInterrupt:
		pass
