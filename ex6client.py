import socket
s = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
s.connect(('localhost',1234))
a=input("ARP or RARP:")
if(a.upper()=="ARP"):
    add = input('Enter IP : ')
elif(a.upper()=="RARP"):
    add = input('Enter MAC : ')
s.send(add.encode())
mac = s.recv(1024)
mac = mac.decode("utf-8")
if(a=="ARP"):
    print('MAC of',add,' is : ',mac)
else:
    print('IP of',add,' is : ',mac)