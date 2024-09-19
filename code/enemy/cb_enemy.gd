extends CharacterBody2D

const SPEED = 64
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var spr_enemy: Sprite2D = $sprEnemy
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var pb_hp: ProgressBar = $pbHP

@export var hp = 25
@export var atk = 1
@export var level:int = 1
@export var enemyType:Global.enemyType = Global.enemyType.CHUPA_CU
@export var xp = 10
@export var enemyName = "Zombie"

@export var spell:PackedScene

var facing = 1
var pos
var previousPosition

var attackTurn = false

var target = null
var goTo = null

func _ready() -> void:
	pb_hp.max_value = hp
	pb_hp.value = hp
	#Global.connect("nextTurn", playTurn)
	pos = global_position
	previousPosition = global_position
	spr_enemy.visible = true
	#levelScale()

func levelScale():
	atk = atk + level
	hp = hp + (level * 2)
	xp = xp + sqrt(xp) * level

func playTurn():
	#await get_tree().create_timer(0.07).timeout
	if attackTurn:
		attack()
	else:
		var moveTo = Vector2(randi_range(-1,1), randi_range(-1,1))
		if goTo != null:
			navigation_agent_2d.target_position = goTo.global_position
			var targetPosition = navigation_agent_2d.get_next_path_position()
			var x
			var y
			moveTo = Vector2(evaluateCoordinate(targetPosition.x, global_position.x), evaluateCoordinate(targetPosition.y, global_position.y))
			#moveTo = to_local(navigation_agent_2d.get_next_path_position().normalized())
		move(moveTo)

func evaluateCoordinate(t, v):
	if t > v:
		return 1
	elif t < v:
		return -1
	return 0

func attack():
	if target != null:
		if enemyType == Global.enemyType.GOBLIN:
			var newSpell = spell.instantiate()
			#var x = 1 if target.global_position.x > global_position.x elif target.global_position.x > global_position.x -1 else 0
			var x = evaluateCoordinate(target.global_position.x, global_position.x)
			if x != facing: flip(x)
			newSpell.direction = Vector2(x, evaluateCoordinate(target.global_position.y, global_position.y))
			newSpell.damage = atk
			add_child(newSpell)
			#newSpell.scale.x *= facing
		else:
			target.getHit(atk + randi_range(0, sqrt(atk)))
			if target == null: return
			match Vector2(evaluateCoordinate(target.global_position.x, global_position.x), evaluateCoordinate(target.global_position.y, global_position.y)):
				Vector2(1,0):
					animation_player.play("attack")
				Vector2(-1,0):
					animation_player.play("attackLeft")
				Vector2(0,1):
					animation_player.play("attackDown")
				Vector2(0,-1):
					animation_player.play("attackUp")

func flip(v = -1):
	spr_enemy.scale.x *= -1
	facing = v

func move(direction):
	if direction:
		pos = global_position
		previousPosition = global_position
		
		if direction.x != 0:
			if direction.x != facing:
				flip(direction.x)
			position.x += SPEED * direction.x
		else:
			position.y += SPEED * direction.y
	else:
		velocity = Vector2(0,0)
	if move_and_slide():
		global_position = previousPosition
		if direction.x != 0:
			move(Vector2(0, direction.y))
			global_position = snapped(global_position, Vector2(32, 32))
	if snapped(pos, Vector2(1,1)) != snapped(global_position, Vector2(1,1)):
		pos = global_position

func getHit(damage:int = 1):
	hp -= damage
	pb_hp.value = hp
	animation_player.play("getHit")
	Global.damageAnimLog.emit(0, damage, global_position)
	Global.damageLog.emit(enemyName + " was hit for " + str(damage) + " damage")
	if hp <= 0:
		queue_free()
		return true
	return false

func _on_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"): 
		attackTurn = true
		target = body

func _on_detection_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"): 
		attackTurn = false
		target = null

func _on_detect_player_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"): 
		goTo = body

func _on_detect_player_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		goTo = null

func _on_navigation_agent_2d_target_reached() -> void:
	goTo = null
