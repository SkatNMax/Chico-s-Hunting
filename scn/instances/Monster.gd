extends KinematicBody2D


# Declare member variables here. Examples:
export var fall_speed = 500
export var fall_acc = 750
export var lat_speed = 50
export var lat_acc = 500
export var lat_air_drag = 5
export var jump_speed = 350
export var dir_rand = 5 # 1/rand_dir to change direction
export var dir_timer = 5 # dir_timer second between every direction change chance


var motion = Vector2(0,0)
var dir = 1
var accel = Vector2(lat_acc, fall_acc)
var hole = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = dir_timer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	# Set the gravity
	if motion.y >= fall_speed:
		motion.y = fall_speed
	else:
		motion.y += accel.y*delta
	
	# Detect hole
	if $RayFD.get_collider() == null or $RayBD.get_collider() == null:
		if hole == false:
			hole = true
			dir *= -1
			#$Timer.start()
			print(name, " dodge hole")
	else:
		hole = false
	
	# Touch walls
	if is_on_wall() == true:
		dir *= -1
	
	# Set left right direction
	if is_on_floor() == true : accel.x = lat_acc
	else: accel.x = lat_acc/lat_air_drag

	if abs (dir * accel.x * delta + motion.x) >= lat_speed:
		motion.x += dir * 0
	else:
		motion.x += dir * accel.x * delta
			
	# Set Jump
	#if is_on_floor() == true and Input.is_action_just_pressed("ui_up"):
	#	motion.y = -jump_speed

	motion = move_and_slide(motion, Vector2.UP)


func _on_Timer_timeout():
	if randi() % dir_rand == 0:
		dir *= -1
		print(name, " change direction for : ", dir)
