extends KinematicBody2D

class_name orbital

export var height: float = .0001
var speed: float
export var theta: float = .0001

func next_point_x():
	return height * sin(theta)

func next_point_y():
	return height * cos(theta)

func distance():
	return sqrt(pow(position.x - Globals.planet_pos.x,2) + pow(position.y - Globals.planet_pos.y,2))
