extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var in_the_screen=false
var MainNode
# Called when the node enters the scene tree for the first time.
func _ready():
	MainNode=get_parent().get_parent()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


#func _on_Area2D_area_entered(area):
#	if area.is_in_group("flies"):
#		MainNode.spawn_flies_from_egg(global_position)
#		queue_free()
#	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	if body.is_in_group("flies"):
		if in_the_screen:
			MainNode.spawn_flies_from_egg(global_position)
			queue_free()
	pass # Replace with function body.


func _on_VisibilityNotifier2D_screen_entered():
	in_the_screen=true
	pass # Replace with function body.


func _on_VisibilityNotifier2D_screen_exited():
	in_the_screen=false
	pass # Replace with function body.
