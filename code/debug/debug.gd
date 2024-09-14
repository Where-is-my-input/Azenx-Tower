extends Node2D

@export var tile:Node2D

const PLAYER = preload("res://code/player/player.tscn")

var playerSpawned = false
var spawnFailSafePos

func _ready() -> void:
	Global.connect("spawnPlayer", playerSpawn)
	Global.connect("floorGenerated", forceSpawn)
	tile.generate()

func playerSpawn(pos, forceSpawn = false):
	spawnFailSafePos = pos
	var rand = randf_range(0, 1)
	#print("random: ", rand)
	if (playerSpawned || rand > 0.1) && !forceSpawn: return
	var player = PLAYER.instantiate()
	add_child(player)
	player.global_position = (Vector2(pos) * Vector2(64, 64)) + Vector2(32, 32)
	#print("spawn position ", pos, " - spawn global position: ", player.global_position)
	playerSpawned = true

func forceSpawn():
	if !playerSpawned:
		playerSpawn(spawnFailSafePos, true)
