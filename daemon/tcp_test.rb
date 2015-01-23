require 'socket'
portnumber = 15244
message='{
	"getRandomNode":1,
	"source":"复旦大学",
	"termination":"草泥马",
	"forbidFlag":2,
	"forbidNode":["sadasdsadasdas","Cosplay","R.O.D"]
}'

socket=TCPSocket.new('127.0.0.1',portnumber);
socket.send(message,0);
res=socket.gets()
puts res
socket.close();

