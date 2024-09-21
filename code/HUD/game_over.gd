extends Control
@onready var igt: Label = $VBoxContainer/HBoxContainer3/igt
@onready var lbl_floor_number: Label = $VBoxContainer/HBoxContainer/lblFloorNumber
@onready var mode: Label = $VBoxContainer/HBoxContainer2/mode

func _ready() -> void:
	lbl_floor_number.text = str(Global.floor)
	var time = "%02d:" % Global.hours
	time += "%02d:" % Global.minutes
	time += "%02d." % Global.seconds
	time += "%03d" % Global.msec
	igt.text = str(time)
	match Global.currentGameMode:
		Global.gameMode.ENDLESS:
			mode.text = "Endless Mode"

func _input(event: InputEvent) -> void:
	if event: get_tree().change_scene_to_file("res://code/HUD/main_menu.tscn")
