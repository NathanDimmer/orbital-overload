extends Control

func _ready():
	Globals.end_layer = -100
	Globals.play_again_layer = -120
	
func _process(delta):
	$CanvasLayer.layer = Globals.play_again_layer

func _on_Button_pressed():
	print("Pressed")
	
	if Globals.play_again_layer == 120:
		Globals.paused = false
	Globals.end_layer = -124
	Globals.play_again_layer = -123
	Globals.reset = false
	
