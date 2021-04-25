extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/buttons/start.get_child(1).connect("pressed",self,"start")
	$CanvasLayer/buttons/intro.get_child(1).connect("pressed",self,"intro")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func start():
	get_tree().change_scene("res://Scenes/Main.tscn")
	
func intro():
	pass
#	get_tree().change_scene("res://Scenes/Main.tscn")
