extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var flies=0
var poop=0
var fly_max_age = Globals.fly_max_age
# Called when the node enters the scene tree for the first time.
func _ready():
	flies=Globals.starting_flies
	pass # Replace with function body.
	
func reset_vars():
	Globals.game_active=true
	fly_max_age = Globals.fly_max_age


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
