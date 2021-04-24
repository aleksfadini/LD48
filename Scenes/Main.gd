extends Node2D
# Window is 640*320
const window_size=Vector2(640,320)
# A level is 20 windows deep and 4 windows wide hence 1720*6400
const map_in_px=Vector2(window_size.x*4,window_size.y*20)
const map_in_tiles=map_in_px/32
const cosmetic_particle_size=512
const big_chunks_cap=0
# Camera Section
var camera_target=map_in_px/2
var camera_target_tolerance=3
var camera_speed=0.03
#var camera_zoom_by_speed_speed=0.03
#var camera_zoom_tolerance=50#within these pixels it will zoom in
var zoom_in_speed=0.01
var zoom_out_speed=0.01
var zoom_in=Vector2(1,1)
var zoom_out=Vector2(1.5,1.5)
#var zoom_out=Vector2(4,4)
# Scenes Preload
var attractionPower=preload("res://Prefabs/attractionForce.tscn")
var floatingBg=preload("res://Prefabs/FloatingThings.tscn")
var flyInst=preload("res://Prefabs/Fly.tscn")
# Script Vars (do not edit)
var noise
var dragging=false
var touch_ignore=false
func _ready():
	# Set Up bg
	set_bg_color()
	generate_fancy_bg()
#	print(": ", map_in_tiles)
	# Set Camera Boundaries
	$Cam.limit_left=0
	$Cam.limit_top=0
	$Cam.limit_right=map_in_px.x
	$Cam.limit_bottom=map_in_px.y
	generate_level()
	generate_starting_point()
func _process(delta):	
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
#	zoom_cam_based_on_speed()
	$CanvasLayer/CamPos.text="Cam Pos: " +str($Cam.global_position.x)+","+str($Cam.global_position.y)
#	$CanvasLayer/CamPos.text="zoom factor: " +str(clamp($Cam.global_position.distance_to(camera_target)/float(camera_zoom_tolerance),zoom_in.x,zoom_out.x))
	$CanvasLayer/Mouse.text="Mouse Pos: " +str(get_global_mouse_position().x)+","+str(get_global_mouse_position().y)
#	$CanvasLayer/Mouse.text="Mouse Pos: " +str($Cam.global_position.distance_to(camera_target))
#	$CanvasLayer/CamPos.text="Cam Pos: " +str($Cam.global_position.x)+","+str($Cam.global_position.y)
#func zoom_cam_ased_on_speed():
#	var zoom_factor=clamp($Cam.global_position.distance_to(camera_target)/float(camera_zoom_tolerance),zoom_in.x,zoom_out.x)
#	$Cam.zoom=lerp($Cam.zoom,Vector2(zoom_factor,zoom_factor),camera_zoom_by_speed_speed)
func move_camera_to_position(target):
	$Cam.position=lerp($Cam.position,target,camera_speed)
func zoom_in_camera():
	if $Cam.zoom.x > (zoom_in.x):
		$Cam.zoom=lerp($Cam.zoom,zoom_in,zoom_in_speed)
func zoom_out_camera():
	if $Cam.zoom.x < (zoom_out.x):
		$Cam.zoom=lerp($Cam.zoom,zoom_out,zoom_out_speed)
func control_cam_and_attract():
	camera_target = get_global_mouse_position()
	if not touch_ignore:
		var s = attractionPower.instance()
		add_child(s)
		s.global_position=get_global_mouse_position()
		touch_ignore=true
		$touchIgnore.start()

func set_bg_color(level=0):
	# Bg Color
	VisualServer.set_default_clear_color(Globals.sky_col[5-level])
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
	make_big_chunks()
#	make_small_walls()
func make_big_chunks():
	for x in map_in_tiles.x:
		for y in map_in_tiles.y:
			var a = noise.get_noise_2d(x,y)
			if a < big_chunks_cap:
				$TileMap.set_cell(x,y,0)		
	$TileMap.update_bitmask_region(Vector2(0.0, 0.0), Vector2(map_in_tiles.x, map_in_tiles.y))
func generate_starting_point():
	var starting_point=Vector2(300,100)
	# will need to find an empty space going row by row, checking that it is empty
	# just delete a bunch of cells around starting point!!!
	camera_target=starting_point
	spawn_flies(Playervars.flies,starting_point)	
func spawn_flies(numb=10,start_point=Vector2()):
	var counter=0
	var point=start_point
	spawn_single_fly(point)
	counter+=1
	var R = true
	var D = true
	var L = true
	var U = true
	# cant believe this junk works
	while counter < numb:
		if R:
			point+=Vector2.RIGHT*counter
			spawn_single_fly(point)
			counter+=1
			R = false
		elif D:
			point+=Vector2.DOWN*counter
			spawn_single_fly(point)
			counter+=1
			D = false			
		elif L:
			point+=Vector2.LEFT*counter
			spawn_single_fly(point)
			counter+=1
			L = false
		elif U:
			point+=Vector2.UP*counter
			spawn_single_fly(point)
			counter+=1
			U = false
		else:
			R = true
			D = true
			L = true
			U = true	
func spawn_single_fly(pos):
	var f = flyInst.instance()
	$Flies.add_child(f)
	f.init()
	f.global_position=pos
func _input(event):
	if event.is_action_pressed("ui_click"):
		dragging= true
	if event.is_action_released("ui_click"):
		dragging=false
	if event.is_action_released("ui_accept"):
		get_tree().reload_current_scene()
func _on_touchIgnore_timeout():
	touch_ignore=false
	$touchIgnore.start()

func eatCell(tile_pos):
	var tile_id = $TileMap.get_cellv(tile_pos)
	if tile_id == 3:
#		velocity=velocity.bounce(collision.normal)
		$TileMap.set_cellv(tile_pos, -500)#this is CRAZYYYY
	elif tile_id < 3:
#				yield($eatCell, "timeout")
		$TileMap.set_cellv(tile_pos, tile_id+1)
	
