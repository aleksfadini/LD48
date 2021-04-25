extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var scroll=false

# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/buttons/start.get_child(1).connect("pressed",self,"start")
	$CanvasLayer/buttons/intro.get_child(1).connect("pressed",self,"intro")
#	$CanvasLayer/buttons/intro.get_child(1).connect("pressed",self,"intro")
	$CanvasLayer/Intro/skip.get_child(1).connect("pressed",self,"start")
	$CanvasLayer/Intro/Bg/SpeechContainer.scroll_vertical=-100
	$CanvasLayer/Intro/Bg/SpeechContainer/Speech.text=txt.introSpeech
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if scroll:
		$CanvasLayer/Intro/Bg/SpeechContainer.scroll_vertical+=1
#	pass

func start():
	get_tree().change_scene("res://Scenes/Main.tscn")
	
func intro():
	$CanvasLayer/Intro.show()
	$CanvasLayer/Intro/intro.play("fade_in")
	pass
#	get_tree().change_scene("res://Scenes/Main.tscn")


func _on_intro_animation_finished(anim_name):
	scroll=true
	pass # Replace with function body.
