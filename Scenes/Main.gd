extends Node2D
# Window is 640*320
# A level is 10 windows deep and 2 windows wide hence 1280*3200
const map_in_px=Vector2(1280,3200)
const map_in_tiles=map_in_px/2
const big_chunks_cap=0.5
# Script Vars (do not edit)
var noise
func _ready():
	# Set Up bg
	set_bg_color()
#	print(": ", map_in_tiles)
func _process(delta):
#		$CanvasLayer/CamPos.text="Cam Pos: " +str($Cam.global_position.x)+","+str($Cam.global_position.y)
	$CanvasLayer/Mouse.text="Mouse Pos: " +str(get_global_mouse_position().x)+","+str(get_global_mouse_position().y)

func set_bg_color(level=0):
	# Bg Color
	VisualServer.set_default_clear_color(Color(1,1,1))
	generate_level()
func generate_level():
#	randomize()
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 1.0
	noise.period = 12
	make_big_chunks()
#	make_small_walls()
func make_big_chunks():
	for x in map_in_tiles.x:
		for y in map_in_tiles.y:
			var a = noise.get_noise_2d(x,y)
			if a < big_chunks_cap:
				$TileMap.set_cell(x,y,-1)		
	$TileMap.update_bitmask_region(Vector2(0.0, 0.0), Vector2(map_in_tiles.x, map_in_tiles.y))

	


