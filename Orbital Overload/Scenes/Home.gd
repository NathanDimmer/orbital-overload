extends Control

func _ready():
	Globals.start_layer = 100
	$CanvasLayer.layer= 120
	Globals.paused = true

func _on_Button_pressed():
	print("Pressed")
	
	if $CanvasLayer.layer == 120:
		Globals.paused = false
	Globals.start_layer = -124
	$CanvasLayer.layer= -123
	
