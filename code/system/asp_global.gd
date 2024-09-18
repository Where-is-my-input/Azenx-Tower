extends AudioStreamPlayer

var menu = true

const BGM_ALPHA = preload("res://assets/soundtracks/BGM_Alpha.mp3")
const BGM_BETA = preload("res://assets/soundtracks/BGM_Beta.mp3")
const BGM_DELTA = preload("res://assets/soundtracks/BGM_Delta.mp3")
const BGM_EPSILON = preload("res://assets/soundtracks/BGM_Epsilon.mp3")
const BGM_GAMMA = preload("res://assets/soundtracks/BGM_Gamma.mp3")
const BGM_MENU = preload("res://assets/soundtracks/BGM_Menu.mp3")
const BGM_OMEGA = preload("res://assets/soundtracks/BGM_Omega.mp3")
const VIKTOR_KRAUS___APPROACHING_THE_TOWER = preload("res://assets/soundtracks/Viktor Kraus - Approaching the Tower.mp3")

func playRandom():
	menu = false
	match randi_range(1,7):
		1:
			stream = BGM_ALPHA
		2:
			stream = BGM_BETA
		3:
			stream = BGM_DELTA
		4:
			stream = BGM_EPSILON
		5:
			stream = BGM_GAMMA
		6:
			stream = BGM_OMEGA
		7:
			stream = VIKTOR_KRAUS___APPROACHING_THE_TOWER
	play()

func playMainMenu():
	menu = true
	stream = BGM_MENU
	play()


func _on_finished() -> void:
	if menu:
		playMainMenu()
	else:
		playRandom()
