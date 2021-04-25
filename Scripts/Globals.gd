extends Node


const attraction_permanence=0.6
const starting_flies=1
const fly_max_age=20
const flies_in_one_egg=5
#const egg_flies_min=2
#const egg_flies_max=8
const eggs_chance=0.1#Was 0.05
#const poop_to_level=1
const attraction_radius=1.5
const poop_to_level=[100,200,400,800,1200,1700,2500,3000,4000,6000,8000,12000]
const zoom_out=Vector2(1.5,1.5)
const poo_per_cell=1
const laser_flies=false
const laser_flies_percentage=0.5#based on 1
const laser_flies_speed_boost=70#based on 1
#const min_abs_eggs_chance=0.05
var game_active=true
var another_menu_already=false
const possiblePowers=["ten more flies","stronger pheromones","stronger flies","gather poo faster", "more fruitful eggs","clairvoyance in the poo", "laser-powered flies"]

const poo_colors=[
	Color(71,36,0,1),
	Color(86,44,1,1),
	Color(96,49,0,1),
	Color(116,59,0,1)
	]

const sky_col=[
	Color("#653D48"),
	Color("#933F45"),
	Color("#B25E46"),
	Color("#CC925E"),
	Color("#DACB80"),
	Color("#F0E9C9")
	]

const sky_col_OLD=[
	Color("#5c5185"),
	Color("#6c7ba1"),
	Color("#8eb4bd"),
	Color("#b2d4c9"),
	Color("#c7edc9"),
	Color("#e5ffe6")
	]

const fly_col=[
	Color("#401B34"),
	Color("#542439"),
	Color("#752E37"),
	Color("#A25845"),
	Color("#D29465"),
	Color("#E4C996")
	]

const enemies_col=[
	Color("#FF1600"),
	Color("#FF3A00"),
	Color("#FF7100"),
	Color("#FF9500"),
	Color("#FFBA00"),
	Color("#FFD500")
	]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
