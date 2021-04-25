extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var flies=0
var poop=0
var fly_max_age
var flies_in_one_egg
var attraction_radius
var poop_to_level
var zoom_out
var poo_per_cell
# Called when the node enters the scene tree for the first time.
func _ready():
	flies=Globals.starting_flies
	pass # Replace with function body.
	
func reset_vars():
	Globals.game_active=true
	fly_max_age = Globals.fly_max_age
	flies_in_one_egg = Globals.flies_in_one_egg
	attraction_radius = Globals.attraction_radius
	poop_to_level = Globals.poop_to_level.duplicate()
	zoom_out = Globals.zoom_out
	poo_per_cell = Globals.poo_per_cell

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
