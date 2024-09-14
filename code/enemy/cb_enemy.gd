extends CharacterBody2D

const SPEED = 64
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var spr_enemy: Sprite2D = $sprEnemy

@export var hp = 25
@export var atk = 1

var pos
var previousPosition

var attackTurn = false

var target = null

func _ready() -> void:
	Global.connect("nextTurn", playTurn)
	pos = global_position
	previousPosition = global_position
	spr_enemy.visible = true

func playTurn():
	await get_tree().create_timer(0.07).timeout
	if attackTurn:
		attack()
	else:
		move(Vector2(randi_range(-1,1), randi_range(-1,1)))

func attack():
	if target != null:
		target.getHit(atk)

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

func getHit(damage = 1):
	hp -= damage
	animation_player.play("getHit")
	if hp <= 0:
		queue_free()


func _on_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"): 
		attackTurn = true
		target = body


func _on_detection_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"): 
		attackTurn = false
		target = null
