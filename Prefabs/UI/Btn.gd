extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var label = "test"
# Called when the node enters the scene tree for the first time.
func _ready():
	init()
	pass # Replace with function body.

func init():
	$Label.text=label
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_button_down():
	$AnimationPlayer.play("pressed")
	$AudioStreamPlayer.play()
	pass # Replace with function body.
