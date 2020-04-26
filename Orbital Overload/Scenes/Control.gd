extends Control

func _process(delta):
	
	var rng = RandomNumberGenerator.new()
	
	rng.randomize()
	
	if Globals.launched != null:
		if Globals.high:
			if Globals.launched > 210 and Globals.launched < 300:
				Globals.score += 1
				if rng.randi_range(0,1) == 1:
					Globals.high = true
				else:
					Globals.high = false
			Globals.launched = null
		else:
			if Globals.launched < 210:
				Globals.score += 1
				if rng.randi_range(0,1) == 1:
					Globals.high = true
				else:
					Globals.high = false
			Globals.launched = null
	
	if Globals.score > Globals.high_score:
		Globals.high_score = Globals.score
	
	$RichTextLabel.text = "Satellites: " + str(Globals.score) + "\nHighest satellites: " + str(Globals.high_score)
	$RichTextLabel2.text = "Objective:\nHigh Earth Orbit" if Globals.high else "Objective:\nLow Earth Orbit"
