extends CharacterBody2D


const SPEED = 64.0
const JUMP_VELOCITY = -400.0
@onready var tmr_movement_cooldown = $"../tmrMovement"
#@onready var audio_move: AudioStreamPlayer2D = $audioMove
#@onready var audio_death: AudioStreamPlayer2D = $audioDeath

var facing = -1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var pos = global_position
var previousPosition = global_position

func _ready():
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
			if facing != direction.x:
				scale.x *= -1
				facing = direction.x
		else:
			position.y += SPEED * direction.y
		tmr_movement_cooldown.start(0.15)
	else:
		velocity = Vector2(0,0)
	if move_and_slide():
		global_position = previousPosition
	
	if snapped(pos, Vector2(1,1)) != snapped(global_position, Vector2(1,1)):
		pos = global_position
		#audio_move.play()
		#swap = false
	
#func die():
	#audio_death.play()
	#Global.restart.emit()
