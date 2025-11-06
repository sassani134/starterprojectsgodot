extends Node

# user://settings.cfg change bien mais n'est jamai load quand
# je relance le jeu


# Why is there not a default video settings
const CONFIG_PATH : String = "user://settings.cfg"

const DEFAULT_CONFIG_PATH : String = "res://Assets/default_settings.cfg"

const DEFAULT_VIDEO_SETTINGS : Dictionary = {
	"resolution": Vector2i(1280,720),
	"fullscreen": false,
	"borderless": false,
	"vsync": true,
}

const DEFAULT_AUDIO_SETTINGS : Dictionary = {
	"master_volume": 0.5,
	"music_volume": 0.5,
	"sfx_volume": 0.5,
}

const DEFAULT_CONTROLS_SETTINGS : Dictionary = {
	"move_up": "W",
	"move_down": "S",
	"move_left": "A",
	"move_right": "D",
}

const DEFAULT_LANGUAGE_SETTINGS : Dictionary = {
	"locale": "en",
}

var video_settings : Dictionary = {
	"resolution": Vector2i(1280,720),
	"fullscreen": false,
	"borderless": false,
	"vsync": true,
}

var audio_settings : Dictionary = {
	"master_volume": 0.5,
	"music_volume": 0.5,
	"sfx_volume": 0.5,
}

var controls_settings : Dictionary = {
	"move_up": "W",
	"move_down": "S",
	"move_left": "A",
	"move_right": "D",
}

var language_settings : Dictionary = {
	"locale": "en",
}

func _ready() -> void:
	load_settings()
	apply_video_settings()
	apply_audio_settings()
	apply_language_settings()
	return

func save_settings() -> void:
	var config : ConfigFile = ConfigFile.new()

	for key in video_settings:
		config.set_value("video", key, video_settings[key])

	for key in audio_settings:
		config.set_value("audio", key, audio_settings[key])

	for key in controls_settings:
		config.set_value("controls", key, controls_settings[key])

	for key in language_settings:
		config.set_value("language", key, language_settings[key])

	config.save(CONFIG_PATH)
	return

func load_settings() -> void:
	var config : ConfigFile = ConfigFile.new()
	var err := config.load(CONFIG_PATH)
	if err != OK:
		return

	for section in ["video", "audio", "controls", "language"]:
		if not config.has_section(section):
			continue

		var target_dict = get(section + "_settings")
		for key in target_dict.keys():
			if config.has_section_key(section, key):
				target_dict[key] = config.get_value(section, key)
	return



func apply_video_settings() -> void:
	var v = video_settings
	DisplayServer.window_set_vsync_mode(
		DisplayServer.VSYNC_ENABLED if v["vsync"] else DisplayServer.VSYNC_DISABLED
	)

	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_FULLSCREEN if v["fullscreen"] else
		DisplayServer.WINDOW_MODE_WINDOWED
	)

	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, v["borderless"])
	DisplayServer.window_set_size(v["resolution"])
	return

func apply_audio_settings() -> void:
	var master_db = linear_to_db(clamp(audio_settings["master_volume"], 0.0, 1.0))
	var music_db = linear_to_db(clamp(audio_settings["music_volume"], 0.0, 1.0))
	var sfx_db = linear_to_db(clamp(audio_settings["sfx_volume"], 0.0, 1.0))

	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),master_db)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),music_db)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"),sfx_db)
	return

func apply_language_settings() -> void:
	TranslationServer.set_locale(language_settings["locale"])
	return
