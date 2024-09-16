extends HBoxContainer
@onready var lbl_name: Label = $lblName
@onready var lbl_atk: Label = $lblAtk

func setResource(m = "Name", a = 1):
	lbl_name.text = m
	lbl_atk.text = str(a)
