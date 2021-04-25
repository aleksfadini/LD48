extends Node2D
# Window is 640*320
const window_size=Vector2(640,320)
# A level is 20 windows deep and 4 windows wide hence 1720*6400
#const map_in_px=Vector2(window_size.x*5,window_size.y*5)
const map_in_px=Vector2(window_size.x*20,window_size.y*20)
const map_in_tiles=map_in_px/32
const cosmetic_particle_size=512
#const big_chunks_cap=1
const big_chunks_cap=-0.1
const mid_chunks_cap=-0.05
const contour_chunks_cap=0
const outside_contour_chunks_cap=0.02
const eggs_min_cap=0.4
const eggs_max_cap=0.6
# Camera Section
var camera_target=map_in_px/2
var camera_target_tolerance=3
var camera_speed=0.03
#var camera_zoom_by_speed_speed=0.03
#var camera_zoom_tolerance=50#within these pixels it will zoom in
var zoom_in_speed=0.01
var zoom_out_speed=0.01
var zoom_in=Vector2(1,1)
#var zoom_in=Vector2(4,4)
#var zoom_out=Vector2(1.5,1.5)
#var zoom_out=Vector2(4,4)
#var zoom_out=Vector2(8,8)
# Scenes Preload
var attractionPower=preload("res://Prefabs/attractionForce.tscn")
var floatingBg=preload("res://Prefabs/FloatingThings.tscn")
var flyInst=preload("res://Prefabs/Fly.tscn")
var eggInst=preload("res://Prefabs/Egg.tscn")
# Script Vars (do not edit)
var noise
var dragging=false
var touch_ignore=false
var apply_power_after_pause=false
var power_to_be_applied=""
var ten_more_flies=0
#var curr_bg_color=
func _ready():
	deactivate_all_menus()
	# reset vars
	apply_power_after_pause=false
	Playervars.reset_vars()
#	zoom_out=Playervars.zoom_out
	# Connect Buttons
	$CanvasLayer/Pause.get_child(1).connect("pressed",self,"launch_pause_menu")
	# Set Up bg
	generate_fancy_bg()
#	print(": ", map_in_tiles)
	# Set Camera Boundaries
	$Cam.limit_left=0
	$Cam.limit_top=0-window_size.y*4 # so you can see the sky
	$Cam.limit_right=map_in_px.x
	$Cam.limit_bottom=map_in_px.y
	generate_level()
	generate_starting_point()
	set_bg_color()
func _physics_process(delta):
	if Globals.game_active:
		$CanvasLayer/CamPos.text="Cam Pos: " +str($Cam.global_position.x)+","+str($Cam.global_position.y)
		$CanvasLayer/Mouse.text="Mouse Pos: " +str(get_global_mouse_position().x)+","+str(get_global_mouse_position().y)
		if dragging:
			control_cam_and_attract()
		if $Cam.position.distance_to(camera_target) >= camera_target_tolerance:
			zoom_out_camera()
			move_camera_to_position(camera_target)
		else:
			zoom_in_camera()
			pass
	else:
		move_camera_to_position(camera_target)
		zoom_out_camera()
#	set_bg_color()
#	zoom_cam_based_on_speed()
#	$CanvasLayer/CamPos.text="Cam Pos: " +str($Cam.global_position.x)+","+str($Cam.global_position.y)
#	$CanvasLayer/Mouse.text="Mouse Pos: " +str(get_global_mouse_position().x)+","+str(get_global_mouse_position().y)
#	$CanvasLayer/Test.text="Test: " +str($Cam.global_position.y/float(map_in_px.y))
#func zoom_cam_ased_on_speed():
#	var zoom_factor=clamp($Cam.global_position.distance_to(camera_target)/float(camera_zoom_tolerance),zoom_in.x,zoom_out.x)
#	$Cam.zoom=lerp($Cam.zoom,Vector2(zoom_factor,zoom_factor),camera_zoom_by_speed_speed)
func move_camera_to_position(target):
	$Cam.position=lerp($Cam.position,target,camera_speed)
func zoom_in_camera():
	if $Cam.zoom.x > (zoom_in.x):
		$Cam.zoom=lerp($Cam.zoom,zoom_in,zoom_in_speed)
func zoom_out_camera():
	if not Globals.game_active:
		var zoom_out=Vector2(20,20)
		if $Cam.zoom.x < (Playervars.zoom_out.x):
			$Cam.zoom=lerp($Cam.zoom,zoom_out,zoom_out_speed)
	if $Cam.zoom.x < (Playervars.zoom_out.x):
		$Cam.zoom=lerp($Cam.zoom,Playervars.zoom_out,zoom_out_speed)
func control_cam_and_attract():
	camera_target = get_global_mouse_position()
	if not touch_ignore:
		var s = attractionPower.instance()
		s.radius=Playervars.attraction_radius
		add_child(s)
		s.global_position=get_global_mouse_position()
		touch_ignore=true
		$touchIgnore.start()

func set_bg_color():
	# Bg Color
#	VisualServer.set_default_clear_color(Globals.sky_col[5-level])
	var levelInFloat=abs($Cam.global_position.y/float(map_in_px.y))
	var level=floor(levelInFloat*5)
	$Parallax/Bg.color=Globals.sky_col[5-level]
	
func generate_fancy_bg():
	#generate every 256 pixels, so:
#	var cosmetic_zoom=4#I like bigger particles
#	var cosmetic_size=cosmetic_particle_size*cosmetic_zoom
	for x in (map_in_px.x/cosmetic_particle_size+1):
		for y in (map_in_px.y/cosmetic_particle_size+1):
			var f = floatingBg.instance()
			$FancyBg.add_child(f)
#			print("vector: ", Vector2(x,y))
			f.global_position=Vector2(x*cosmetic_particle_size,y*cosmetic_particle_size)
#			f.scale=Vector2(cosmetic_zoom,cosmetic_zoom)
#			f.global_position=Vector2(x,y)
func generate_level():
#	randomize()
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 12.0
	noise.period = 12
	make_outside_contour_chunks()
	make_contour_chunks()
	make_mid_chunks()
	make_big_chunks()
	lay_eggs()
#	make_small_walls()
func make_big_chunks():
	for x in map_in_tiles.x:
		for y in map_in_tiles.y:
			var a = noise.get_noise_2d(x,y)
			if a < big_chunks_cap:
				$TileMap.set_cell(x,y,0)		
	$TileMap.update_bitmask_region(Vector2(0.0, 0.0), Vector2(map_in_tiles.x, map_in_tiles.y))
func make_contour_chunks():
	for x in map_in_tiles.x:
		for y in map_in_tiles.y:
			var a = noise.get_noise_2d(x,y)
			if a < contour_chunks_cap:
				$TileMap.set_cell(x,y,1)		
	$TileMap.update_bitmask_region(Vector2(0.0, 0.0), Vector2(map_in_tiles.x, map_in_tiles.y))
func make_mid_chunks():
	for x in map_in_tiles.x:
		for y in map_in_tiles.y:
			var a = noise.get_noise_2d(x,y)
			if a < mid_chunks_cap:
				$TileMap.set_cell(x,y,2)		
	$TileMap.update_bitmask_region(Vector2(0.0, 0.0), Vector2(map_in_tiles.x, map_in_tiles.y))

func make_outside_contour_chunks():
	for x in map_in_tiles.x:
		for y in map_in_tiles.y:
			var a = noise.get_noise_2d(x,y)
			if a < outside_contour_chunks_cap:
				$TileMap.set_cell(x,y,3)		
	$TileMap.update_bitmask_region(Vector2(0.0, 0.0), Vector2(map_in_tiles.x, map_in_tiles.y))


func lay_eggs():
	for x in map_in_tiles.x:
		for y in map_in_tiles.y:
			var a = noise.get_noise_2d(x,y)
#			if a > big_chunks_cap and a < eggs_cap:
			if a > eggs_min_cap and a < eggs_max_cap:
#				print("Trying to spawn egg, a: ", a)
				var true_eggs_chance= Globals.eggs_chance*(y/float(map_in_tiles.y))
#				var true_egg_chance = max(true_eggs_chance,0.01)
				print("true egg_chance: ", true_eggs_chance)
				if randf() <= true_eggs_chance:
					var pos=Vector2(x,y)*32+Vector2(16,16)
#				var pos=Vector2(x+16,y+16)
#				$TileMap.set_cell(x,y,0)
					print("egg at: ", pos)
					var f = eggInst.instance()
					$PickUps.add_child(f)
#				f.init()
					f.global_position=pos	


func generate_starting_point():
#	var starting_point=Vector2(window_size.x-100,window_size.y*2-290)
#	var starting_point=Vector2(window_size.x*3-100,window_size.y*5-290)

# final:
	var starting_point=Vector2(window_size.x*10-100,window_size.y*20-290)
	# will need to find an empty space going row by row, checking that it is empty
	# just delete a bunch of cells around starting point!!!
	# convert starting_point to tile coordinates
	var start_in_tiles_coords=starting_point/32
	# delete tiles around it
	# THIS IS WHY I AM STUPID
	var tilesAroundStart=[-3,-2,-1,0,1,2,3]
	for x in tilesAroundStart:
		for y in tilesAroundStart:
			if (not ((x==y and x>=3)) 
			and (not (x==y and x<=-3))
			and (not (x==-y and y>=3))
			and (not (x==-y and y<=-3))):
				var each_pos=Vector2(start_in_tiles_coords)+Vector2(x,y)
				$TileMap.set_cellv(each_pos, -2000)
	$Cam.global_position=starting_point
	camera_target=starting_point
	spawn_flies(Playervars.flies,starting_point)	
func spawn_flies(numb=10,start_point=Vector2()):
	for i in numb:
		var fly_scale =4 # to account for fly size
		var boundary=fly_scale*numb/2
		var rand_x = rand_range(-boundary,boundary)
		var rand_y = rand_range(-boundary,boundary)
		var point = Vector2(rand_x,rand_y)+start_point
#		print("spawning fly at: ", point)
		spawn_single_fly(point)
#		spawn_single_fly(start_point)
	
#	var counter=0
#	var point=start_point
#	spawn_single_fly(point)
#	counter+=1
#	var R = true
#	var D = true
#	var L = true
#	var U = true
#	# cant believe this junk works
#	while counter < numb:
#		if R:
#			point+=4*Vector2.RIGHT*counter
#			spawn_single_fly(point)
#			counter+=1
#			R = false
#		elif D:
#			point+=4*Vector2.DOWN*counter
#			spawn_single_fly(point)
#			counter+=1
#			D = false			
#		elif L:
#			point+=4*Vector2.LEFT*counter
#			spawn_single_fly(point)
#			counter+=1
#			L = false
#		elif U:
#			point+=4*Vector2.UP*counter
#			spawn_single_fly(point)
#			counter+=1
#			U = false
#		else:
#			R = true
#			D = true
#			L = true
#			U = true	
func spawn_single_fly(pos):
	var f = flyInst.instance()
	f.global_position=pos
	$Flies.add_child(f)
#	f.init()
func _input(event):
	if event.is_action_pressed("ui_click"):
		dragging= true
	if event.is_action_released("ui_click"):
		dragging=false
	if event.is_action_released("ui_accept"):
#		game_won(Vector2(0,0))
		game_lost()
#		get_tree().reload_current_scene()
func _on_touchIgnore_timeout():
	touch_ignore=false
	$touchIgnore.start()
########################################3
# Called From Other Scenes
func eatCell(tile_pos):
#	if true:
#		return
	var tile_id = $TileMap.get_cellv(tile_pos)
	if tile_id == 3:
#		velocity=velocity.bounce(collision.normal)
		Playervars.poop+=Playervars.poo_per_cell
		$TileMap.set_cellv(tile_pos, -999999999)#this is CRAZYYYY
	elif 0 <= tile_id and tile_id < 3:
#				yield($eatCell, "timeout")
		$TileMap.set_cellv(tile_pos, tile_id+1)
func spawn_flies_from_egg(egg_position):
#	spawn_5_flies(egg_position)
#	var number_of_flies=rand_range(Globals.egg_flies_min,Globals.egg_flies_max)
	var number_of_flies=Playervars.flies_in_one_egg
	spawn_flies(number_of_flies,egg_position)
#despreate attempt to optimize
func spawn_5_flies(pos):
	var dist=4
	var vect0=pos
	var vect1=pos+dist*Vector2.RIGHT
	var vect2=pos+dist*Vector2.LEFT
	var vect3=pos+dist*Vector2.UP
	var vect4=pos+dist*Vector2.DOWN
	spawn_single_fly(vect0)
	spawn_single_fly(vect1)
	spawn_single_fly(vect2)
	spawn_single_fly(vect3)
	spawn_single_fly(vect4)
# buttons functions
func launch_pause_menu():
	if not Globals.another_menu_already:
		$CanvasLayer/MsgCont/MsgBox/PauseMenu.show()
		show_msg()
	else:
		pass
func resume_from_menu():
	$CanvasLayer/MsgCont/msg.play_backwards("resume_inverse")

func _on_updateLabels_timeout():
	$CanvasLayer/Poop.text="Poo: " +str(Playervars.poop)
	if Playervars.poop>=Playervars.poop_to_level[0]:
		Playervars.poop_to_level.remove(0)
#		Playervars.poop=0
#		deactivate_all_menus()
		$CanvasLayer/MsgCont/MsgBox/PowerUpMenu.show()
		$CanvasLayer/MsgCont/MsgBox/PowerUpMenu.init()
		show_msg()
	var flies=$Flies.get_child_count()
	$CanvasLayer/Flies.text="Flies: " +str(flies)
	if flies == 0 and Globals.game_active:
		game_lost()
	
	pass # Replace with function body.


func _on_WinTrigger_body_entered(body):
	if Globals.game_active and body.is_in_group("flies") and body.is_visible() and $Triggers/WinTrigger.is_visible():
			var notif=VisibilityNotifier2D.new()
			body.add_child(notif)
			notif.connect("screen_entered",self,"game_won",[body.global_position])
#			if notif.is_on_screen():
			pass
	pass # Replace with function body.
func game_won(pos):
#	print("game won!!!", pos)
	Globals.game_active=false
	$CanvasLayer/MsgCont/MsgBox/YouWin.show()
	camera_target=pos
	show_msg()
	

func game_lost():
	Globals.game_active=false
	$CanvasLayer/MsgCont/MsgBox/YouLose.init()
	$CanvasLayer/MsgCont/MsgBox/YouLose.show()	
	show_msg()
	pass

func show_msg(): 
	Globals.another_menu_already=true
	if Globals.game_active:
		get_tree().paused=true
	$CanvasLayer/MsgCont/msg.play("show")
	$CanvasLayer/MsgCont/MsgBox.show()

# hide what needs to be hiddn
func _on_msg_animation_finished(anim_name):
	if anim_name=="resume_inverse":
		get_tree().paused=false
		Globals.another_menu_already=false
		deactivate_all_menus()
		if apply_power_after_pause:
			apply_power()
		
	pass # Replace with function body.

func deactivate_all_menus():
	$CanvasLayer/MsgCont/MsgBox.position.y=600
	$CanvasLayer/MsgCont/MsgBox.hide()
	$CanvasLayer/MsgCont/MsgBox/YouLose.hide()
	$CanvasLayer/MsgCont/MsgBox/YouWin.hide()
	$CanvasLayer/MsgCont/MsgBox/PauseMenu.hide()
	$CanvasLayer/MsgCont/MsgBox/PowerUpMenu.hide()
	pass

###############################
##### POWERUPS
func flag_power_to_be_applied(power):
	power_to_be_applied=power
	apply_power_after_pause=true

func apply_power():
	apply_power_after_pause=true
	if power_to_be_applied=="ten more flies":
		ten_more_flies=0
		$TenMoreFlies.start()
	if power_to_be_applied=="stronger pheromones":
		Playervars.attraction_radius+=0.5
	if power_to_be_applied=="stronger flies":
		Playervars.fly_max_age+=5
	if power_to_be_applied=="gather more poo":
		Playervars.poo_per_cell+=1
	if power_to_be_applied=="more fruitful eggs":
		Playervars.flies_in_one_egg+=10
	if power_to_be_applied=="clairvoyance in the poo":
		Playervars.zoom_out+=Vector2(0.5,0.5)
	power_to_be_applied="nothing"	



func _on_TenMoreFlies_timeout():
	if ten_more_flies<=10:
		spawn_single_fly(get_global_mouse_position())
		ten_more_flies+=1
		$TenMoreFlies.start()
	pass # Replace with function body.
