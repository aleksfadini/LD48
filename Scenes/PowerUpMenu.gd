extends Node2D

var power1=""
var power2=""

func _ready():
#	$restart.get_child(1).connect("pressed",self,"restart")
	$power1.get_child(1).connect("pressed",self,"power1")
	$power2.get_child(1).connect("pressed",self,"power2")
	pass # Replace with function body.
#
#func restart():
#	get_tree().reload_current_scene()
	
func resume():
	get_parent().get_parent().get_parent().get_parent().resume_from_menu()
	
#func quit():
#	get_tree().change_scene("res://Scenes/Title.tscn")
func init():
	pick_rand_powers()
	$power1.label=power1
	$power1.label=power2
	
func pick_rand_powers():
	var powerUps=Globals.powerUps.duplicate()
	var rand_i=randi()%powerUps.size()
	power1=powerUps[rand_i]
	powerUps.remove(rand_i)
	power2=powerUps[randi()%powerUps.size()]
	
func power1():
	get_parent().get_parent().get_parent().get_parent().applypower(power1)
	
func power2():
	get_parent().get_parent().get_parent().get_parent().applypower(power2)