extends Control

export var server_url = "ws//localhost:3333/echo"

var _client = WebSocketClient.new()

func _ready():
	_client.connect("connection_closed", self, "ws_closed")
	_client.connect("connection_error", self, "ws_closed")
	_client.connect("connection_established", self, "ws_connected")
	_client.connect("data_received", self, "ws_data_received")
	
	var err = _client.connect_to_url(server_url)
	if err != OK:
		print("Unnable to connect")
		set_process(false)

func _on_Input_text_entered(new_text):
	print("ENTERED", new_text)
	$Container/Input.text = ""
	$Container/Output.append_bbcode("[color=#00FF00][Send][/color] " + new_text + "\n")

func ws_closed():
	print("CLOSE")
	set_process(false)
	
func ws_connected():
	pass
	
func ws_data_received():
	pass
