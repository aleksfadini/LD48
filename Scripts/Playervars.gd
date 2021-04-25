extends Node


var flies = 0
var poop = 0
var fly_max_age
var flies_in_one_egg
var attraction_radius
var poop_to_level
var zoom_out
var poo_per_cell
var laser_flies
var possiblePowers
func _ready():
	reset_vars()
func reset_vars():
	get_tree().paused=false
	poop=0
	flies=0
	flies=Globals.starting_flies
	Globals.game_active=true
	fly_max_age = Globals.fly_max_age
	flies_in_one_egg = Globals.flies_in_one_egg
	attraction_radius = Globals.attraction_radius
	poop_to_level = Globals.poop_to_level.duplicate()
	zoom_out = Globals.zoom_out
	poo_per_cell = Globals.poo_per_cell
	laser_flies = Globals.laser_flies
	possiblePowers = Globals.possiblePowers

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
