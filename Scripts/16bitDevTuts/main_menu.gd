extends Control

@export_category("Menu VBoxContainer")
@export var menu: VBoxContainer
@export var main_settings: VBoxContainer
@export var video_settings: VBoxContainer
@export var audio_settings: VBoxContainer
@export var controls_settings: VBoxContainer
@export var language_settings: VBoxContainer

@export_category("Buttons")
@export var start_button : Button
@export var settings_button : Button
@export var quit_button : Button
@export var video_button: Button
@export var audio_button: Button
@export var controls_button: Button
@export var language_button: Button
@export var back_button: Button
@export var reset_button: Button

var nav_stack: Array[Control] = []
var current_panel

func _ready() -> void:
	current_panel = menu
	_show_panel(menu)
	_update_back_button()
	
	back_button.pressed.connect(_on_back_pressed)
	reset_button.pressed.connect(_on_reset_pressed)
	start_button.pressed.connect(_on_start_pressed)
	settings_button.pressed.connect(_navigate_to.bind(main_settings))
	quit_button.pressed.connect(_on_quit_pressed)
	video_button.pressed.connect(_navigate_to.bind(video_settings))
	audio_button.pressed.connect(_navigate_to.bind(audio_settings))
	controls_button.pressed.connect(_navigate_to.bind(controls_settings))
	language_button.pressed.connect(_navigate_to.bind(language_settings))
	return

func _show_panel(panel: Control) -> void:
	panel.visible = true
	return

func _update_back_button() -> void:
	back_button.visible = nav_stack.size() > 0
	return

func _update_reset_button() -> void:
	reset_button.visible = nav_stack.size() > 1
	return

func _navigate_to(panel: Control) -> void:
	if current_panel:
		nav_stack.append(current_panel)
		current_panel.visible = false
	
	current_panel = panel
	_show_panel(current_panel)
	_update_back_button()
	return

func _on_back_pressed() -> void:
	if nav_stack.is_empty():
		return
	
	current_panel.visible = false
	current_panel = nav_stack.pop_back()
	_show_panel(current_panel)
	_update_back_button()
	SettingsManager.save_settings()
	return

func _on_reset_pressed() -> void:
	SettingsManager.reset_default_settings()
	return

func _on_quit_pressed() -> void:
	get_tree().quit()
	return

func _on_start_pressed() -> void:
	# get_tree().change_scene_to_file()
	print("No Game file")
	return
