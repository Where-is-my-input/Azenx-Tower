extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var camera_2d: Camera2D = $Camera2D
@onready var aim: ColorRect = $aim
@onready var asp_attack: AudioStreamPlayer2D = $aspAttack
@onready var asp_spell: AudioStreamPlayer2D = $aspSpell

signal dead
signal collectItem

const SPEED = 64.0
const JUMP_VELOCITY = -400.0
@onready var tmr_movement_cooldown = $"../tmrMovement"
#@onready var audio_move: AudioStreamPlayer2D = $audioMove
#@onready var audio_death: AudioStreamPlayer2D = $audioDeath
@onready var as_player: AnimatedSprite2D = $asPlayer

@export var spell:PackedScene
@export var weapon:Node2D
@export var hp:int = 25
@export var maxHP:int = 25
@export var level:int = 1
@export var atk:int = 2
@export var mana:int = 50
@export var maxMana:int = 50

var xp:int = 0
var xpNeeded:int = level + ((25 + level) * level) + sqrt(level)
var teleportCooldown = 0
var teleportRange = 2
var blockMovement = false

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
	Global.connect("limitCamera", limitCamera)
	Global.connect("enemyTurn", startTurn)
	Global.updateHUDLevel.emit(self)
	Global.updateHUDxp.emit(self)
	if testOutsideBoundaries():
		global_position = Vector2(32, 32)

func limitCamera(limitLeft, limitRight, limitTop, limitBottom):
	camera_2d.limit_left = limitLeft
	camera_2d.limit_right = limitRight
	camera_2d.limit_top = limitTop
	camera_2d.limit_bottom = limitBottom

func startTurn():
	blockMovement = false

func nextTurn():
	teleportCooldown -= 1

func passiveManaRegen():
	regenMana(level + sqrt(level))

func finished(value):
	#set_script(null)
	queue_free()

func _physics_process(delta):
	direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	if direction && tmr_movement_cooldown.is_stopped() && !blockMovement:
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
		if direction:
			dirLooking = direction
	#if move:
	if move_and_slide():
		if !Global.godMode:
			#if global_position == previousPosition:
				#position.x += SPEED * 1
				#position.y += SPEED * 1
				#move_and_slide()
			if global_position != previousPosition: 
				global_position = previousPosition
				blockMovement = false
				if move_and_slide():
					global_position = Vector2(32, 32)
	else:
		playAnimation(dirLooking)
		if dirLooking:
			aim.global_position = global_position + (Vector2(64, 64) * teleportRange ) * dirLooking
			weapon.global_position = (dirLooking * Vector2(64, 64)) + global_position
			weapon.flip(dirLooking)
		#if direction != Vector2(0,0): weapon.global_position = (direction * Vector2(64, 64)) + global_position
		#if direction != Vector2(0,0) && !tmr_movement_cooldown.is_stopped(): Global.nextTurn.emit()
	if snapped(pos, Vector2(1,1)) != snapped(global_position, Vector2(1,1)):
		blockMovement = true
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

func testOutsideBoundaries():
	if position.x > camera_2d.limit_right || position.x < camera_2d.limit_left || position.y > camera_2d.limit_bottom || position.y < camera_2d.limit_top:
		return true
	return false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") && tmr_movement_cooldown.is_stopped() && !blockMovement:
		blockMovement = true
		weapon.attack()
		asp_attack.play()
		tmr_movement_cooldown.start(0.15)
	elif event.is_action_pressed("teleport") && !blockMovement:
		if testOutsideBoundaries():
			global_position = Vector2(32, 32)
		var manaRequired:int = (maxMana * 0.05) * (teleportRange - 1)
		if teleportCooldown <= 0 && mana >= manaRequired:
			previousPosition = global_position
			position += dirLooking * (SPEED * teleportRange)
			if move_and_slide() || testOutsideBoundaries():
				Global.manaLog.emit("Path obstructed")
				global_position = previousPosition
				blockMovement = false
			else:
				Global.teleported.emit()
				blockMovement = true
				teleportCooldown = 5
				useMana(manaRequired)
				teleportRange = 2
				Global.updateHUD.emit(self)
				tmr_movement_cooldown.start(0.25)
		elif mana < manaRequired:
			Global.manaLog.emit("Not enough mana")
			Global.manaLog.emit(str(manaRequired) + " required")
		else:
			Global.manaLog.emit("Teleport is in cooldown")
			Global.manaLog.emit(str(teleportCooldown) + " turns left")
	elif event.is_action_pressed("spell") && !blockMovement:
		var manaRequired:int = maxMana * 0.25
		if mana >= manaRequired:
			asp_spell.play()
			blockMovement = true
			var usedSpell = spell.instantiate()
			usedSpell.direction = dirLooking
			usedSpell.manaDamage = mana
			useMana(manaRequired)
			add_child(usedSpell)
			Global.updateHUD.emit(self)
		else:
			Global.manaLog.emit("Not enough mana")
			Global.manaLog.emit(str(manaRequired) + " required")
	elif event.is_action_pressed("collect"):
		collectItem.emit()
	if event.is_action_pressed("tpRangeUp"):
		teleportRange -= 1
		if teleportRange < 2:
			teleportRange = 2
	elif event.is_action_pressed("tpRangeDown"):
		teleportRange += 1
		if teleportRange > 8 || mana < (maxMana * 0.05) * (teleportRange - 1):
			teleportRange -= 1

func spellFinished():
	#blockMovement = false
	Global.nextTurn.emit()

#func _on_tmr_movement_timeout() -> void:
	#as_player.stop()
func getHit(damage = 1):
	if !Global.godMode: hp -= damage
	Global.damageLog.emit("You were hit for " + str(damage) + " damage")
	Global.damageAnimLog.emit(0, damage, global_position)
	Global.updateHUD.emit(self)
	animation_player.play("getHit")
	if hp <= 0:
		hp = 0
		dead.emit()
		get_parent().dead()

func leaveFloor():
	get_parent().process_mode = Node.PROCESS_MODE_DISABLED
	get_parent().get_parent().remove_child(get_parent())
	Global.player = get_parent()

func heal(v:int = 1):
	if hp < maxHP: 
		Global.damageLog.emit("Healed for " + str(v) + " HP")
		Global.damageAnimLog.emit(1, v, global_position)
	hp += v
	Global.updateHUD.emit(self)
	if hp > maxHP:
		hp = maxHP

func getXP(v:int = 1):
	xp += v
	Global.damageLog.emit("Gained " + str(v) + " XP")
	Global.updateHUDxp.emit(self)
	Global.damageAnimLog.emit(4, str(v) + " xp", global_position)
	levelUp()

func calculateXpNeeded():
	xpNeeded = level + ((25 + level) * level) + sqrt(level)

func levelUp():
	if xp >= xpNeeded:
		level += 1
		Global.damageLog.emit("Leveled up to level " + str(level))
		Global.damageAnimLog.emit(2, "Level up!", global_position)
		xp -= xpNeeded
		calculateXpNeeded()
		scaleStats()
		Global.updateHUDLevel.emit(self)
		Global.updateHUD.emit(self)
		levelUp()

func useMana(v:int = 1):
	mana -= v
	Global.damageAnimLog.emit(3, -v, global_position)
	Global.damageLog.emit(str(-v) + " mana used")

func regenMana(v:int = 1):
	if mana < maxMana:
		Global.damageLog.emit(str(v) + " mana regenerated")
		Global.damageAnimLog.emit(3, v, global_position)
	mana += v
	if mana > maxMana:
		mana = maxMana
	Global.updateHUD.emit(self)

func scaleStats():
	maxHP = maxHP + level + 2
	maxMana = maxMana + level + sqrt(level)
	heal(maxHP / 2)
	atk = atk + 1

func equipWeapon(w):
	weapon.queue_free()
	weapon = w
	add_child(weapon)
	Global.updateHUDResources.emit(self)


func _on_turn_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		body.add_to_group("PlayTurn")


func _on_turn_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		body.remove_from_group("PlayTurn")
