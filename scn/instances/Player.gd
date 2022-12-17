extends KinematicBody2D

signal health_depleted
signal haelth_gained

# Declare member variables here. Examples:
export var fall_speed = 500
export var fall_acc = 750
export var lat_speed = 300
export var lat_acc = 1000
export var lat_air_drag = 5
export var jump_speed = 350
export var hit_speed = 200


var motion = Vector2(0,0)
var dir = 0
var accel = Vector2(lat_acc, fall_acc)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	# Set the gravity
	if is_on_floor() == true:
		motion.y = fall_acc*delta
	elif motion.y >= fall_speed:
		motion.y = fall_speed
	else:
		motion.y += accel.y*delta
	
	
	# Set left right direction
	dir = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	if is_on_floor() == true : accel.x = lat_acc
	else: accel.x = lat_acc/lat_air_drag

	if dir == 0:
		if abs(motion.x) < accel.x * delta: motion.x = 0
		elif motion.x > 0: motion.x -= accel.x * delta
		elif motion.x < 0: motion.x += accel.x * delta
		
	else:
		if abs (dir * accel.x * delta + motion.x) >= lat_speed:
			motion.x += dir * 0
		else:
			motion.x += dir * accel.x * delta
			
	# Set Jump
	if is_on_floor() == true and Input.is_action_just_pressed("ui_up"):
		motion.y = -jump_speed
		
	# Hit monster collision layer
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.get_collision_layer() == pow(2,2):
			motion = collision.normal*hit_speed
			# Hit recovery
			if $HitTimer.time_left == 0:
				emit_signal("health_depleted")
				$HitTimer.start()
				print("Hit monster ")
			
			
	motion = move_and_slide(motion, Vector2.UP)
	
	# Apply slash attack
	if Input.is_action_just_pressed("gp_slash") == true and $AnimationPlayer.is_playing() == false:
		$AnimationPlayer.play("Slash")
		



func _on_Champi_body_entered(body):
	emit_signal("haelth_gained")


func _on_AnimationPlayer_animation_started(anim_name):
	$Weapon.get_child(0).monitoring = true


func _on_AnimationPlayer_animation_finished(anim_name):
	$Weapon.get_child(0).monitoring = false
