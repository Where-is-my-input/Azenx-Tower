extends Control

@onready var master: HSlider = $VBoxContainer/master
@onready var bgm: HSlider = $VBoxContainer/bgm
@onready var sfx: HSlider = $VBoxContainer/sfx
@onready var va: HSlider = $VBoxContainer/va
@onready var aspsfx: AudioStreamPlayer = $sfx
@onready var aspva: AudioStreamPlayer = $va

const DB_MAX = 6
const DB_MIN = -24

@onready var masterBus = AudioServer.get_bus_index("Master")
@onready var sfxBus = AudioServer.get_bus_index("sfx")
@onready var vaBus = AudioServer.get_bus_index("va")
@onready var bgmBus = AudioServer.get_bus_index("bgm")


func _ready() -> void:
	GetBaseVolume()
	
func GetBaseVolume() -> void:
	master.value = db_to_linear(AudioServer.get_bus_volume_db(masterBus))
	bgm.value = db_to_linear(AudioServer.get_bus_volume_db(bgmBus))
	sfx.value = db_to_linear(AudioServer.get_bus_volume_db(sfxBus))
	va.value = db_to_linear(AudioServer.get_bus_volume_db(vaBus))


func _on_master_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(masterBus, linear_to_db(value))


func _on_bgm_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bgmBus, linear_to_db(value))


func _on_sfx_value_changed(value: float) -> void:
	aspsfx.play()
	AudioServer.set_bus_volume_db(sfxBus, linear_to_db(value))

func _on_va_value_changed(value: float) -> void:
	aspva.play()
	AudioServer.set_bus_volume_db(vaBus, linear_to_db(value))

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://code/HUD/main_menu.tscn")
