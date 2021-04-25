extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#export var label=""

# Called when the node enters the scene tree for the first time.
func _ready():
	_on_AnimationPlayer_animation_finished("funky")
#	text=label
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name=="funky":
		var anim=$AnimationPlayer.get_animation("funky")
#		var t_secs = 0.1
#		shrink_anim.track_remove_key(0,0)
	#	shrink_anim.track_remove_key(0,1)
#		shrink_anim.track_insert_key(0,0,start_color)
#		shrink_anim.track_insert_key(0,t_secs,final_color)
#		var transp_color=Color(1,1,1,0)
		var position1=Vector2(rand_range(-10,10),rand_range(-10,10))
		var position2=Vector2(rand_range(-10,10),rand_range(-10,10))
		var position3=Vector2(rand_range(-10,10),rand_range(-10,10))
		anim.track_set_key_value(2,1,position1)
		anim.track_set_key_value(2,2,position2)
		anim.track_set_key_value(2,3,position3)
#		shrink_anim.track_set_key_value(2,1,transp_color)
		$AnimationPlayer.playback_speed=rand_range(0.1,1.2)
		self_modulate=Globals.sky_col[randi()%5]
#		self_modulate=Globals.poo_colors[randi()%4]
		$AnimationPlayer.play("funky")

	pass # Replace with function body.
