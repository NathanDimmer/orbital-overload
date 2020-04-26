extends orbital

export var debris1: PackedScene
export var debris2: PackedScene

onready var explosion_player = $ExplosionPlayer
onready var rocket_player = $RocketPlayer

var rng = RandomNumberGenerator.new()

var dead

var life = 100

var planet_death = false

var thrusters = true
var rocketing = false

signal destroyed()

func _ready():
	on_create()
	dead = false
	$Explosion.visible = false
	visible = true
	$"Collision Detector".monitorable = true
	$"Collision Detector".monitoring = true
	$Explosion.stop()
	
func _physics_process(delta):
	if Globals.reset:
		queue_free()
	update_health()
	if Globals.current_name == get_name():
		$Highlight.visible = true
	else:
		$Highlight.visible = false
	if !dead:
		get_input(delta)
		speed = PI/(height/30)
	if !Globals.paused:
		theta -= speed * delta
		var new_pos = Vector2(next_point_x(), next_point_y())
		position.x = Globals.planet_pos.x + new_pos.x
		position.y = Globals.planet_pos.y + new_pos.y
		look_at(Vector2(Globals.planet_pos.x, Globals.planet_pos.y))
	else:
		var new_pos = Vector2(next_point_x(), next_point_y())
		position.x = Globals.planet_pos.x + new_pos.x
		position.y = Globals.planet_pos.y + new_pos.y
	
	if rocketing and thrusters and !rocket_player.playing:
		rocket_player.playing = true
		
	if !rocketing or !thrusters and rocket_player.playing:
		rocket_player.playing = false
	
func get_input(delta): 
	if Globals.current_name == get_name():
		if Input.is_action_pressed("up") and thrusters:
			height += 50 * delta
			degrade_heath(delta)
			rocketing = true
		elif Input.is_action_pressed("down") and thrusters:
			height -= 50 * delta
			degrade_heath(delta)
			rocketing = true
		else:
			rocketing = false
	


func _on_Collision_Detector_area_entered(body):
	explosion_player.play()
	dead = true
	$Explosion.visible = true
	$Explosion.play()
	
	$"Collision Detector".monitorable = false
	$"Collision Detector".monitoring = false

	
#	var new_debris_2 = debris1.instance()
#
	
#	new_debris_2.on_create(speed + rng.randf_range(-PI/10,PI/10), theta - PI/6, height + rng.randf_range(-4,4))
	

	$"Kill Timer".start()


func _on_Planet_Detector_body_entered(body):
	explosion_player.play()
	planet_death = true
	dead = true
	$Explosion.visible = true
	$Explosion.play()
	$"Collision Detector".monitorable = false
	$"Collision Detector".monitoring = false
	
	$"Kill Timer".start()

	
func update_health():
	$Health.value = life
	if life > 50:
		$Health.modulate = "#148400"
	elif life < 50 && life > 25:
		$Health.modulate = "#c67400"
	elif life < 25:
		$Health.modulate = "#ab0000"
		if life < 1 and thrusters:
			thrusters = false
			
func degrade_heath(delta):
	life -= Globals.degridation_rate * delta

func _on_Kill_Timer_timeout():
	if !planet_death:
		var new_debris_1 = debris1.instance()
		new_debris_1.on_create(speed, theta, height)
		get_parent().add_child(new_debris_1,true)
		
		var new_debris_2 = debris2.instance()
		new_debris_2.on_create(speed, theta, height)
		get_parent().add_child(new_debris_2,true)
	
	emit_signal("destroyed")
	queue_free()
	pass




func _on_Button_pressed():
	Globals.current_name = get_name()
	print(Globals.current_name)


func on_create(new_height = null, new_theta = null):
	if new_height != null:
		height = new_height
	else:
		if height == .0001:
			height = 300
	if new_theta != null:
		theta = new_theta
	else:
		if theta == .0001:
			theta = PI


func _on_Sat_destroyed():
	Globals.score -= 1
