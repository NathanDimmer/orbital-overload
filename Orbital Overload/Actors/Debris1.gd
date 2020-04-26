extends orbital

export var debris2: PackedScene

var rng = RandomNumberGenerator.new()

var dead

onready var explosion_player = $ExplosionPlayer

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
	
	if !Globals.paused and !height < 50:
		theta -= speed * delta
		var new_pos = Vector2(next_point_x(), next_point_y())
		position.x = Globals.planet_pos.x + new_pos.x
		position.y = Globals.planet_pos.y + new_pos.y
		look_at(Vector2(sin(theta), cos(theta)))
	elif !Globals.paused:
		explosion_player.play()
		dead = true
		$Explosion.visible = true
		$Explosion.play()
		
		$"Collision Detector".monitorable = false
		$"Collision Detector".monitoring = false

		$"Kill Timer".start()
	
func _on_Collision_Detector_area_entered(body):
	if $"Spawn Timer".is_stopped():
		explosion_player.play()
		dead = true
		$Explosion.visible = true
		$Explosion.play()
		
		$"Collision Detector".monitorable = false
		$"Collision Detector".monitoring = false
		
		
	
	#	var new_debris_1 = debris1.instance()
	#	var new_debris_2 = debris1.instance()
	#
	#	new_debris_1.on_create(speed + rng.randf_range(-PI/10,PI/10), theta, height + rng.randf_range(-3,3))
	#	new_debris_2.on_create(speed + rng.randf_range(-PI/10,PI/10), theta - PI/6, height + rng.randf_range(-4,4))
		
	
		$"Kill Timer".start()


func _on_Planet_Detector_body_entered(body):
	explosion_player.play()
	dead = true
	$Explosion.visible = true
	$Explosion.play()
	$"Collision Detector".monitorable = false
	$"Collision Detector".monitoring = false
	
	$"Kill Timer".start()
	
func _on_Kill_Timer_timeout():
	
	var new_debris_1 = debris2.instance()
	new_debris_1.on_create(speed, theta, height)
	get_parent().add_child(new_debris_1,true)
	
	var new_debris_2 = debris2.instance()
	new_debris_2.on_create(speed, theta, height)
	get_parent().add_child(new_debris_2,true)
	
	queue_free()
	pass

func on_create(new_speed = null, new_theta = null, new_height = null):
	rng.randomize()
	
	theta = new_theta if new_theta != null else theta
	
	height = new_height if new_height != null else height
	
	speed = new_speed if new_speed != null else (PI/(height/15))
	
	theta += rng.randf_range(-PI/180, PI/180)
	height += rng.randf_range(-25,25)
	speed += rng.randf_range(0,PI/300)
