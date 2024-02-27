import socket 

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.connect(("localhost", 11235))
sock.sendall(b"True")
sock.close()