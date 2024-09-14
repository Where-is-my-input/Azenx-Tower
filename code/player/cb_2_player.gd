extends CharacterBody2D


const SPEED = 64.0
const JUMP_VELOCITY = -400.0
@onready var tmr_movement_cooldown = $"../tmrMovement"
#@onready var audio_move: AudioStreamPlayer2D = $audioMove
#@onready var audio_death: AudioStreamPlayer2D = $audioDeath
@onready var as_player: AnimatedSprite2D = $asPlayer

@export var weapon:Node2D
@export var hp = 100

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var pos = global_position
var previousPosition = global_position

func _ready():
	weapon.global_position.x += 64
	#Global.connect("topdownFinished", finished)
	pos = global_position

func finished(value):
	#set_script(null)
	queue_free()

func _physics_process(delta):
	var direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	if direction && tmr_movement_cooldown.is_stopped():
		pos = global_position
		previousPosition = global_position
		
		if direction.x != 0:
			position.x += SPEED * direction.x
		else:
			position.y += SPEED * direction.y
		tmr_movement_cooldown.start(0.15)
	else:
		velocity = Vector2(0,0)
	if move_and_slide():
		global_position = previousPosition
		pass
	else:
		playAnimation(direction)
		if direction != Vector2(0,0): weapon.global_position = (direction * Vector2(64, 64)) + global_position
		#if direction != Vector2(0,0) && !tmr_movement_cooldown.is_stopped(): Global.nextTurn.emit()
	if snapped(pos, Vector2(1,1)) != snapped(global_position, Vector2(1,1)):
		Global.nextTurn.emit()
		pos = global_position
		#audio_move.play()
		#swap = false
	
#func die():
	#audio_death.play()
	#Global.restart.emit()

func playAnimation(direction):
	match direction:
		Vector2(0,1):
			as_player.play("down")
		Vector2(0,-1):
			as_player.play("up")
		Vector2(1,0):
			as_player.play("right")
		Vector2(-1,0):
			as_player.play("left")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		weapon.attack()
		tmr_movement_cooldown.start(0.15)

#func _on_tmr_movement_timeout() -> void:
	#as_player.stop()
func getHit(damage = 1):
	hp -= damage
	if hp <= 0:
		queue_free()
