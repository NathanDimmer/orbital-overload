extends Node

var screen_width = ProjectSettings.get_setting("display/window/size/width")
var screen_height = ProjectSettings.get_setting("display/window/size/height")
var planet_pos = Vector2(screen_width/2, screen_height/2)

var current_name = ""

var paused = false

var degridation_rate = 20

var launching = false

var score = 0

var high_score = 0

var high = true

var launched = null

var start_layer = 10

var play_again_layer = -120

var reset = false

var end_layer = -100

var debris = 0
