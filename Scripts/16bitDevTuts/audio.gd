extends VBoxContainer

@export_category("sliders")
@export var master_slider: HSlider
@export var music_slider: HSlider
@export var sfx_slider: HSlider
# label for % is call w/ full route
@export_category("buttons")
@export var button_music : Button
@export var button_sfx : Button

const MIN_DB = -60.0
const MAX_DB = 0.0

func _ready() -> void:
	_sync_sliders()
	
	master_slider.value_changed.connect(_on_master_volume_changed)
	music_slider.value_changed.connect(_on_music_volume_changed)
	sfx_slider.value_changed.connect(_on_sfx_volume_changed)
	button_music.toggled.connect(_on_button_music_toggled)
	button_sfx.pressed.connect(_on_button_sfx_pressed)
	pass

func _sync_sliders() -> void:
	master_slider.value = _db_to_slider(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	music_slider.value = _db_to_slider(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	sfx_slider.value = _db_to_slider(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
	$HBoxContainer/Label.text = str(int(_db_to_slider(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))))) + "%"
	$HBoxContainer2/Label.text = str(int(_db_to_slider(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))))) + "%"
	$HBoxContainer3/Label.text = str(int(_db_to_slider(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))))) + "%"
	pass

func _slider_to_db(value: float) -> float:
	if value <= 0.0:
		return MIN_DB
	
	var linear = value / 100.0
	var db = linear_to_db(linear)
	return clampf(db, MIN_DB, MAX_DB)

func _db_to_slider(db: float) -> float:
	if db <= MIN_DB:
		return .0
	var linear = db_to_linear(db)
	return clampf(linear * 100, 0.0, 100.0)

func _set_volume(bus_name: String, value: float) -> void:
	var db = _slider_to_db(value)
	var bus_index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, db)
	AudioServer.set_bus_mute(bus_index,db <= MIN_DB)

func _on_master_volume_changed(value: float)-> void:
	_set_volume("Master", value)
	$HBoxContainer/Label.text = (str(int(value))+"%")

func _on_music_volume_changed(value: float)-> void:
	_set_volume("Music", value)
	$HBoxContainer2/Label.text = (str(int(value))+"%")

func _on_sfx_volume_changed(value: float)-> void:
	_set_volume("SFX", value)
	$HBoxContainer3/Label.text = (str(int(value))+"%")

func _on_button_music_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$HBoxContainer4/ButtonMusic/AudioStreamPlayer.play()
	else :
		$HBoxContainer4/ButtonMusic/AudioStreamPlayer.stop()
	pass

func _on_button_sfx_pressed() -> void:
	$HBoxContainer4/ButtonSFX/AudioStreamPlayer.play()
	pass
