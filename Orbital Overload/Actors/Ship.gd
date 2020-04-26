extends KinematicBody2D

var acceleration = Vector2(0,-100)
var velocity = Vector2(0,0)

export var satellite: PackedScene
export var debris1: PackedScene

onready var rocket_player = $RocketPlayer

signal launched(height)

func _ready():
	position.x = Globals.planet_pos.x
	position.y = Globals.planet_pos.y - 60
	$Explosion.visible = false
	$CPUParticles2D.visible = true

func _physics_process(delta):
	if !Globals.paused:
		velocity.y += acceleration.y * delta
		get_input()
		if Globals.launching:
			move_and_slide(velocity, Vector2.UP)
		elif $BoomTimer.is_stopped():
			queue_free()
	

func get_input():
	if Input.is_action_just_pressed("launch") and Globals.launching:
		rocket_player.playing = false
		Globals.launching = false
		var new_sat = satellite.instance()
		new_sat.on_create(abs(position.y - Globals.planet_pos.y))
		emit_signal("launched", abs(position.y - Globals.planet_pos.y))
		get_parent().add_child(new_sat)
		queue_free()


func _on_Area2D_area_entered(area):
	Globals.launching = false
	$Explosion.visible = true
	$CPUParticles2D.visible = false
	$Explosion.play()
	if $BoomTimer.is_stopped():
		$BoomTimer.start()
	



func _on_Boom_Timer_timeout():
	var new_debris_1 = debris1.instance()
	new_debris_1.on_create(null, 0, abs(position.y - Globals.planet_pos.y))
	get_parent().add_child(new_debris_1,true)
	queue_free()


func _on_Node2D_launched(height):
	Globals.launched = height
