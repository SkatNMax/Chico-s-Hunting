extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var nav = Navigation2D
var line = Path2D

var target = 0
var snap = 0.05
var speed = 200.0

var fall_speed = 5.0
var fall_acc = 0.1
var jump_speed = 30.0
var jump_acc = 5
var jump_want = 50 #percent

var drag_air = 0.9
var drag_water = 0.2
 
var motion = Vector2(0,0)
var on_jump_line = false

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	var scene = get_tree().current_scene
	nav = get_node("/root/"+ scene.name +"/FishesNavigation2D")
	line = get_node("/root/"+ scene.name +"/FishesJumpLine")

	get_travel(scene, nav)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#--------------------------------------
	# ECRIRE CETTE PARTIE SUR PAPIER!!!!!!!
	#--------------------------------------
	
	# Set the gravity
	var drag = drag_air
	

	if is_in_water(line) == false: 
		if motion.y >= fall_speed:
			motion.y = fall_speed
		else:
			motion.y += fall_acc
		
	else: # 
		if is_on_jump_line(line) == true:
			if motion.y <= -jump_speed:
				motion.y = -jump_speed
			else:
				motion.y -= jump_acc
				
		else:
			var path = nav.get_simple_path(position, target)
			
			if len(path) > 1:
				# Get the motion
				motion = (path[1]-position).normalized()
				
				# Flip the sprite
				if motion.x < 0: $AnimatedSprite.flip_v = true
				elif motion.x > 0: $AnimatedSprite.flip_v = false
				
				# If target is not too close
				if (path[1]-position).length() > snap*speed:
					pass
					#move_and_slide(motion*speed)
				# Else reset a new path
				else:
					var scene = get_tree().current_scene
					get_travel(scene, nav)
			
	move_and_slide(motion*speed)
	#print(name, motion)
		
	look_at(position + motion)
			
			
func is_on_jump_line(line):
	var closest = line.curve.get_closest_point(position)
	if position.distance_to(closest) < snap * speed:
		print(name, " want to make the magic jump")
		return true

	else:
		#print(name, " want to back in the water world")
		return false
			
		
func is_in_water(line):
	var closest = line.curve.get_closest_point(position)
	if closest.y < position.y: return true
	else: return false
		
func get_travel(scene, nav):
	
	# Pick random tile
	target = randi() % len(scene.fishes_spawn)
	target = scene.fishes_spawn[target]
	
