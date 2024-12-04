import socket
server=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
server_address=('localhost',10000)
server.bind(server_address)
server.listen(1)
print("waiting for connection")
connection, client_address=server.accept()
message=" "
while message!="end":
    data=connection.recv(1000).decode()
    if data:
        print("client:",data)
        message=input("server:")
        connection.sendall(message.encode())
    else:
        break
connection.close()
server.close()
