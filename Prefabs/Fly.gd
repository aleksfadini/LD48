extends KinematicBody2D

var transitionTimeMin = 0.2 # was 5
var transitionTimeMax = 2 # was 10
var speedMin = 140
var speedMax = 250
var attractionSpeed = 200
var maxVelocity = 200
var age = 0 # number of turns
var max_age = 10 # then they die. this number is replaced by randomizer
var maxAgeMin=30
var maxAgeMax=70
var chance_of_not_eating=0.9
var food_value=5
var lastVec = null
var nextVec = Vector2(0,0)
var velocity = Vector2(0,0)
#var _instant_pos = Vector2(0,0)
var critter_type = "fly"
#var this_critter_group = "none"
#var cannot_reproduce = true
#var refractaryPeriodTime=4 # seconds
var scaredSpeed=1.5
var MainNode
func _ready():
	init("fly")
	MainNode=get_parent().get_parent()
#	$randomizeDir.start()

#func _process(delta):
func _physics_process(delta):
	# This code is just for choosing target positions, in your game just use your tiles
#	if lastVec == null:
#		_instant_pos = get_position()
#		_last_pos = _instant_pos
#		randomizeNextVec()
#	if nextVec != null:
#		move_and_collide(nextVec)
#	move_and_collide(nextVec)
	if age >= max_age:
		queue_free()
	velocity.clamped(maxVelocity)
	var collision = move_and_collide(velocity*delta)
	# Confirm the colliding body is a TileMap
	if collision:
		if collision.collider.is_in_group("flies"):
		
		#			if critter_type != "red":
#				queue_free()
#				collision.collider.set_age(-food_value)
#				if critter_type == "blue":
#					get_parent().elephants -= 1
#				if critter_type == "green":
#					get_parent().rabbits -= 1
#				get_parent().update_pop_tot()
#			else:
			velocity=velocity.bounce(collision.normal)
		if collision.collider is TileMap:
			if randf() > chance_of_not_eating:
				# Find the character's position in tile coordinates
				var tile_pos = collision.collider.world_to_map(position)
				# Find the colliding tile position
				tile_pos -= collision.normal
				# Get the tile id
#				var tile_id = collision.collider.get_cellv(tile_pos)
				MainNode.eatCell(tile_pos)
#				if tile_id >= 3:
#					velocity=velocity.bounce(collision.normal)
#					collision.collider.set_cellv(tile_pos, -1)
#				elif tile_id < 3:
#	#				yield($eatCell, "timeout")
#					collision.collider.set_cellv(tile_pos, tile_id+1)
			else:
				pass
					
func init(type="fly"):
	max_age=rand_range(maxAgeMin,maxAgeMax)
	if type == "fly":
		$Sprite.self_modulate= Color(0,0,0)
#		$ActualSprite.self_modulate= Color(1,0,0)
		add_to_group("flies")
		critter_type = "fly"
#		speedMax*=2
#		transitionTimeMax/=float(2)
#		transitionTimeMin/=float(2)
#		max_age/=float(1.5)
		scale=Vector2(4,4)		
#	just_reproduced()
	$randomizeDir.start()
	
	
func randomizeNextVec():
	var newVect=Vector2(rand_range(-1,1),rand_range(-1,1)).normalized() * rand_range(speedMin,speedMax)
	nextVec=newVect
	velocity=nextVec


#func _on_changeDir_timeout():

	
#	pass # Replace with function body.


func _on_refractaryPeriod_timeout():
#	cannot_reproduce=false
	pass # Replace with function body.

#func just_reproduced():
#	cannot_reproduce=true
#	$refractaryPeriod.wait_time=refractaryPeriodTime
#	$refractaryPeriod.start()
	
func set_age(number):
	age+=number


func _on_randomizeDir_timeout():
	age+=1
	randomizeNextVec()
	$randomizeDir.wait_time = rand_range(transitionTimeMin,transitionTimeMax)
	$randomizeDir.start()
	pass # Replace with function body.
