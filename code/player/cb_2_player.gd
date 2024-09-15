extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

const SPEED = 64.0
const JUMP_VELOCITY = -400.0
@onready var tmr_movement_cooldown = $"../tmrMovement"
#@onready var audio_move: AudioStreamPlayer2D = $audioMove
#@onready var audio_death: AudioStreamPlayer2D = $audioDeath
@onready var as_player: AnimatedSprite2D = $asPlayer

@export var weapon:Node2D
@export var hp = 25
@export var maxHP = 25
@export var level = 1
@export var atk = 2

var xp = 0
var xpNeeded:int = level + ((25 + level) * level) + sqrt(level)
var teleportCooldown = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var move = false
var pos = global_position
var previousPosition = global_position

var direction = Vector2(0,0)
var dirLooking = Vector2(0,-1)

func _ready():
	calculateXpNeeded()
	weapon.global_position.x += 64
	#Global.connect("topdownFinished", finished)
	pos = global_position
	Global.updateHUD.emit(self)
	Global.connect("nextTurn", nextTurn)
	Global.updateHUDLevel.emit(self)
	Global.updateHUDxp.emit(self)

func nextTurn():
	teleportCooldown -= 1

func finished(value):
	#set_script(null)
	queue_free()

func _physics_process(delta):
	direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	if direction && tmr_movement_cooldown.is_stopped():
		if direction == dirLooking:
			move = true
		else:
			move = false
		pos = global_position
		previousPosition = global_position
		
		if move:
			if direction.x != 0:
				position.x += SPEED * direction.x
			else:
				position.y += SPEED * direction.y
		tmr_movement_cooldown.start(0.25)
		dirLooking = direction
	else:
		velocity = Vector2(0,0)
	#if move:
	if move_and_slide():
		if !Global.godMode:
			#if global_position == previousPosition:
				#position.x += SPEED * 1
				#position.y += SPEED * 1
				#move_and_slide()
			global_position = previousPosition
	else:
		playAnimation(direction)
		if direction != Vector2(0,0): weapon.global_position = (direction * Vector2(64, 64)) + global_position
		#if direction != Vector2(0,0) && !tmr_movement_cooldown.is_stopped(): Global.nextTurn.emit()
	if snapped(pos, Vector2(1,1)) != snapped(global_position, Vector2(1,1)):
		Global.nextTurn.emit()
		#move = false
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
	elif event.is_action_pressed("teleport") && teleportCooldown <= 0:
		previousPosition = global_position
		position += dirLooking * (SPEED * 2)
		if move_and_slide():
			global_position = previousPosition
		else:
			Global.teleported.emit()
			teleportCooldown = 5
			tmr_movement_cooldown.start(0.25)

#func _on_tmr_movement_timeout() -> void:
	#as_player.stop()
func getHit(damage = 1):
	if !Global.godMode: hp -= damage
	Global.updateHUD.emit(self)
	animation_player.play("getHit")
	if hp <= 0:
		queue_free()

func leaveFloor():
	get_parent().process_mode = Node.PROCESS_MODE_DISABLED
	get_parent().get_parent().remove_child(get_parent())
	Global.player = get_parent()

func heal(v = 1):
	hp += v
	Global.updateHUD.emit(self)
	if hp > maxHP:
		hp = maxHP

func getXP(v = 1):
	xp += v
	Global.updateHUDxp.emit(self)
	levelUp()

func calculateXpNeeded():
	xpNeeded = level + ((25 + level) * level) + sqrt(level)

func levelUp():
	if xp >= xpNeeded:
		level += 1
		xp -= xpNeeded
		calculateXpNeeded()
		scaleStats()
		Global.updateHUDLevel.emit(self)
		Global.updateHUD.emit(self)
		levelUp()

func scaleStats():
	maxHP = maxHP + level + 2
	heal(maxHP / 2)
	atk = atk + 1
