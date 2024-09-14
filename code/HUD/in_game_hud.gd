extends Control
@onready var progress_bar: ProgressBar = $CanvasLayer/topHUD/ProgressBar
@onready var door_coordinates: Label = $CanvasLayer/topHUD/doorCoordinates

func _ready() -> void:
	Global.connect("updateHUD", update)
	Global.connect("setDoorCoordinates", setDoorCoordinates)
	door_coordinates.visible = false

func update(player):
	progress_bar.value = player.hp

func setDoorCoordinates(v):
	door_coordinates.text = str(v)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("doorCoordinates"):
		door_coordinates.visible = !door_coordinates.visible
