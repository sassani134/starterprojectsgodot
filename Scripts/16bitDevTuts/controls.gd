extends VBoxContainer

@export_category("Controllers")
@export var up_button: Button
@export var down_button: Button
@export var left_button: Button
@export var right_button: Button

const ACTIONS = {
	"up": "move_up",
	"down": "move_down",
	"left": "move_left",
	"right": "move_right"
}

var waiting_for_input: String = ""

func _ready() -> void:
	_update_button_labels()
	
	#bind est utilise ici pour ne pas ecrire 4 fois la meme fonction
	up_button.pressed.connect(_on_rebind_button_pressed.bind("up"))
	down_button.pressed.connect(_on_rebind_button_pressed.bind("down"))
	left_button.pressed.connect(_on_rebind_button_pressed.bind("left"))
	right_button.pressed.connect(_on_rebind_button_pressed.bind("right"))
	pass

func _get_button(direction: String) -> Button:
	match direction:
		"up": return up_button
		"down": return down_button
		"left": return left_button
		"right": return right_button
		_: return null

func _update_button_label(direction: String) ->void:
	var action_name = ACTIONS[direction]
	var events = InputMap.action_get_events(action_name)
	
	var label_text = "Unassigned"
	
	if events.size() > 0:
		var event = events[0]
		if event is InputEventKey:
			if event.keycode !=0:
				label_text = OS.get_keycode_string(event.keycode)
			elif event.physical_keycode !=0:
				label_text = OS.get_keycode_string(event.physical_keycode)
	
	var btn = _get_button(direction)
	btn.text = "%s" % [label_text]
	pass

func _update_button_labels() -> void:
	for dir in ACTIONS.keys():
		_update_button_label(dir)
	pass

func _on_rebind_button_pressed(direction: String) -> void:
	waiting_for_input = direction
	var btn = _get_button(direction)
	btn.text = "..."
	set_process_input(true)
	pass

func _input(event: InputEvent) -> void:
	if waiting_for_input == "":
		return
	
	if event is InputEventKey and event.pressed:
		var direction = waiting_for_input
		var action_name = ACTIONS[direction]
		
		InputMap.action_erase_events(action_name)
		InputMap.action_add_event(action_name, event)
		
		_update_button_label(direction)
		
		waiting_for_input = ""
		set_process_input(false)
	pass
