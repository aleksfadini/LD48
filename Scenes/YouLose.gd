extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$restart.get_child(1).connect("pressed",self,"restart")
	pass # Replace with function body.

func init():
	var stupid_losing_sentences=[
		"No more flies. I know you like poop, but you have to lead the flies away...",
		"No more flies. And you just spent some time in the poo. Are you proud?",
		"No more flies. You have been defeated by the poop.",
		"All the flies are dead. Now you understand the dangers of the Mythical Poo Mountain.",
		"No more flies. Don't give up, no one wants to handle this menure!",
#		"No more flies! You'll never make new larvae like this.",
		"No more flies. Becoming the Lord of The Flies takes strategy and luck.",
		"Don't lose hope. Luke Flywalker, you have to train the poo. The poo is strong in you."
	]

	$Label.text=stupid_losing_sentences[randi()%stupid_losing_sentences.size()]

func restart():
	get_tree().reload_current_scene()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
