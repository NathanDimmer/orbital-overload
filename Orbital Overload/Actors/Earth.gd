extends Node2D

export var ship: PackedScene 

func _ready():
	position.x = Globals.planet_pos.x
	position.y = Globals.planet_pos.y

func _physics_process(delta):
	if Input.is_action_just_pressed("pause"):
		Globals.paused = !Globals.paused
	if Input.is_action_just_pressed("launch") and !Globals.launching:
		var new_ship = ship.instance()
		get_parent().add_child(new_ship)
		Globals.launching = true
