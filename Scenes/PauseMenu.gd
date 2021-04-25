extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$restart.get_child(1).connect("pressed",self,"restart")
	$resume.get_child(1).connect("pressed",self,"resume")
	$quit.get_child(1).connect("pressed",self,"quit")
	pass # Replace with function body.

func restart():
	get_tree().reload_current_scene()
	
func resume():
	get_parent().get_parent().get_parent().get_parent().resume_from_menu()
	
func quit():
	get_tree().change_scene("res://Scenes/Title.tscn")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
