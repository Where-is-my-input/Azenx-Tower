extends Node
const PLAYER = preload("res://code/player/player.tscn")
const ASP_GLOBAL = preload("res://code/system/asp_global.tscn")

signal nextTurn
signal enemyTurn
signal floorGenerated
signal spawnPlayer
signal spawnEnemy
signal spawnExit
signal spawnSpike
signal spawnItem
signal setDoorCoordinates

signal teleported
signal updateHUD
signal updateHUDLevel
signal updateHUDResources
signal updateHUDxp
signal limitCamera
signal damageLog
signal manaLog
signal damageAnimLog

var godMode = false

enum gameMode { ARCADE, ENDLESS }
enum enemyType { CHUPA_CU, SPIRIT_WOLF, GOBLIN }
enum weaponType { AXE, SWORD, FIREBALL, BOMB, HANDS }

var currentGameMode = gameMode.ARCADE
var seed = "azenx"
var floor = 0
var endlessFloor = 0

var player:Node2D = null
var soundTrack = null

func _ready() -> void:
	soundTrack = ASP_GLOBAL.instantiate()
	add_child(soundTrack)
	instantiatePlayer()
	RenderingServer.set_default_clear_color(Color.BLACK)#DARK_SLATE_GRAY

func healPlayer():
	player.fullHeal()

func _input(event: InputEvent) -> void:
	return
	if event.is_action_pressed("reset"):
		instantiatePlayer()
		get_tree().change_scene_to_file("res://code/main.tscn")
	elif event.is_action_pressed("primeTest"):
		Global.floor += 1
		var xpNeeded:int = floor + ((25 + floor) * floor) + sqrt(floor)
		var floorMobLevel:int = floor - (sqrt(floor) * 2) + floor - sqrt(floor) + 1 - sqrt(floor)
		floorMobLevel = floor - sqrt(floor) * 2 + 2
		print(floorMobLevel, " - ", floor)

func primeTest():
	var tester = 2
	if Global.floor % tester == 0: return false
	tester += 1
	while tester <= sqrt(Global.floor):
		if Global.floor % tester == 0:
			return false
		tester += 2
	return true

func changeFloor():
	if floor % 10 == 0: 
		get_tree().change_scene_to_file("res://code/boss/boss_phase_one.tscn")
		return
	if primeTest():
		get_tree().change_scene_to_file("res://code/world/camp_fire.tscn")
	else:
		get_tree().change_scene_to_file("res://code/debug/debug.tscn")

func instantiatePlayer():
	#if player == null || player.is_empty(): 
	player = PLAYER.instantiate()
	add_child(player)
	remove_child(player)

var showTimer = false
var timed = false
var time: float = 0.0
var hours: int = 0
var minutes: int = 0
var seconds: int = 0
var msec: int = 0

func _process(delta):
	time += delta
	msec = fmod(time, 1) * 100
	seconds = fmod(time, 60)
	minutes = fmod(time, 3600) / 60
	hours = floor(time / 60 / 60 / 60)

func resetIGT():
	time = 0.0
	hours = 0
	minutes = 0
	seconds = 0
	msec = 0
