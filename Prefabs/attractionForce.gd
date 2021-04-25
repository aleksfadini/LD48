extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var permanence = 0.4 #seconds
export var radius = 1.5
# Called when the node enters the scene tree for the first time.
func _ready():
	scale=Vector2(radius,radius)
	$Particles.amount=24*radius
	$Particles.scale_amount=radius
	$Particles.emitting=true
	$die.wait_time=Globals.attraction_permanence
	$die.start()
#	$Sprite/disappear.playback_speed=1/float(permanence)
#	$Sprite/disappear.play("disappear")
	pass # Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_die_timeout():
	queue_free()
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
#	body.velocity=body.velocity
	if body.is_in_group("flies"):
		body.velocity=(global_position-body.global_position).normalized()*body.attractionSpeed
	pass # Replace with function body.
