extends Control

@onready var label: Label = $Label

var device_id : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#label.text = Input.get_joy_name(0)
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventKey or InputEventMouseMotion or InputEventMouseButton:
		label.text = "Keyboard + mouse"
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		device_id = event.device
		var name = Input.get_joy_name(device_id)
		label.text = name
	pass
