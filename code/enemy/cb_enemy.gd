extends CharacterBody2D

const SPEED = 64

var pos
var previousPosition

func _ready() -> void:
	Global.connect("nextTurn", playTurn)
	pos = global_position

func playTurn():
	move(Vector2(randi_range(-1,1), randi_range(-1,1)))

func move(direction):
	if direction:
		pos = global_position
		previousPosition = global_position
		
		if direction.x != 0:
			position.x += SPEED * direction.x
		else:
			position.y += SPEED * direction.y
	else:
		velocity = Vector2(0,0)
	if move_and_slide():
		global_position = previousPosition
	if snapped(pos, Vector2(1,1)) != snapped(global_position, Vector2(1,1)):
		pos = global_position
