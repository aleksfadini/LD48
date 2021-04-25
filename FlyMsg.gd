extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$center/Graphics/Fill.self_modulate=Globals.poo_colors[randi()%2+1]
	$center/Graphics/Foreground.self_modulate=Globals.poo_colors[0]
	init()
	pass # Replace with function body.

func init():
	$center/Label.text=txt.flySentences[randi()%txt.flySentences.size()]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
