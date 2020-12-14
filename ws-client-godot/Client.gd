extends Node

# Won't work with "localhost" should be the local address
export var server_url = "ws://192.168.1.139:3333/echo"

var _client = WebSocketClient.new()
onready var _input: LineEdit = get_node("../Container/Input")
onready var _output: RichTextLabel = get_node("../Container/Output")

enum LogType {
	CLIENT,
	SERVER,
	ERROR
}

func _ready():	
	print_output(LogType.CLIENT, "Connecting", server_url)

	_input.connect("text_entered", self, "send_text")

	_client.connect("connection_closed", self, "ws_closed")
	_client.connect("connection_error", self, "ws_error")
	_client.connect("connection_established", self, "ws_connected")
	_client.connect("data_received", self, "ws_data_received")
	_client.connect("server_close_request", self, "ws_server_close_request")
	
	_client.verify_ssl = false
	
	var err = _client.connect_to_url(server_url)
	if err != OK:
		print("Unnable to connect")
		set_process(false)
	else:
		print("OK")
		
func _process(delta):
	_client.poll()

func send_text(text):
	_input.text = ""
	ws_send_data(text)

func ws_closed(was_clean = false):
	print_output(LogType.ERROR, "Error", "Closed connection. Clean? " + was_clean)
	set_process(false)

func ws_error():
	print_output(LogType.ERROR, "Error", "Error connecting")
	print(_client.get_connection_status())
	set_process(false)
	
func ws_connected(proto = ""):
	print_output(LogType.SERVER, "Connected", "Connected to " + server_url + ". Proto " + proto)
	
func ws_send_data(text):
	print_output(LogType.CLIENT, "Sent", text)
	_client.get_peer(1).put_packet(text.to_utf8())
	
func ws_data_received():
	var message = _client.get_peer(1).get_packet().get_string_from_utf8()
	print_output(LogType.SERVER, "Received", message)
	
func ws_server_close_request():
	print_output(LogType.SERVER, "Received", "Close request")
	
func print_output(type, operation, message):
	var log_str = "[%s] %s" % [ operation, message ];
	var color
	
	match type:
		LogType.CLIENT: color = "#00FF00"
		LogType.SERVER: color = "#0000FF"
		LogType.ERROR: color = "#FF0000"
	
	print(log_str)
	var text = "[color=%s]%s[/color]\n" % [ color, log_str ]
	_output.append_bbcode(text)
