extends KinematicBody2D

signal health_depleted
signal haelth_gained

# Declare member variables here. Examples:
export var fall_speed = 1000
export var fall_acc = 750
export var lat_speed = 450
export var lat_acc = 1000
export var lat_air_drag = 5
export var jump_speed = 500
export var hit_speed = 200


var motion = Vector2(0,0)
var dir = 0
var accel = Vector2(lat_acc, fall_acc)
var on_floor = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	#===========================================================
	# Utiliser plutot la vitesse de déplacement plutot de flip_h
	#=================================================
	var cam_target_x = abs($CamTarget.position.x)
	if $AnimatedSprite.flip_h == true:
		$CamTarget.position.x = cam_target_x
	else:
		$CamTarget.position.x = -cam_target_x


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
	dir = int(Input.is_action_pressed("gp_forward")) - int(Input.is_action_pressed("gp_back"))
	if is_on_floor() == true :
		accel.x = lat_acc
	else:
		accel.x = lat_acc/lat_air_drag
	
	if dir == 0:
		if abs(motion.x) < accel.x * delta: motion.x = 0
		elif motion.x > 0: motion.x -= accel.x * delta
		elif motion.x < 0: motion.x += accel.x * delta
		
	else:
		# Apply motion
		if abs (dir * accel.x * delta + motion.x) >= lat_speed:
			motion.x += dir * 0
		else:
			motion.x += dir * accel.x * delta
		# Flip the sprite following the direction
		if dir > 0:
			$AnimatedSprite.flip_h = true
		elif dir < 0:
			$AnimatedSprite.flip_h = false
		
			
	# Set Jump
	if is_on_floor() == true and Input.is_action_just_pressed("gp_jump"):
		motion.y = -jump_speed
		
		
	# Hit monster collision layer
	""""
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.get_collision_layer() == pow(2,2):
			motion = collision.normal*hit_speed
			# Hit recovery
			if $HitTimer.time_left == 0:
				emit_signal("health_depleted")
				$HitTimer.start()
				print("Hit monster")
	"""
	
	set_animation_and_sound(motion)
	motion = move_and_slide(motion, Vector2.UP)
	

func set_animation_and_sound(motion):
	var current_anim = $AnimatedSprite.get_animation()
	var current_frame = $AnimatedSprite.get_frame()
	var is_one_loop = $AnimatedSprite.get_sprite_frames().get_animation_loop(current_anim)
	var frame_count = $AnimatedSprite.get_sprite_frames().get_frame_count(current_anim)
		
	#if is_one_loop:
	if is_on_floor() == true and Input.is_action_just_pressed("gp_jump"):
		$AnimatedSprite.set_animation("jump_in")
	elif is_on_floor() == false and Input.is_action_just_pressed("gp_slash"):
		$AnimatedSprite.set_animation("jump_attack")
		$SoundEffect/Slash2.play()
		
	elif is_on_floor() == true and Input.is_action_just_pressed("gp_slash"):
		$AnimatedSprite.set_animation("attack")
		$SoundEffect/Slash1.play()
		
	elif current_anim != "attack":
		if abs(motion.x) > 0 and is_on_floor() == true and current_anim == "stop":
			$AnimatedSprite.set_animation("run_start")
		elif abs(motion.x) > 0 and is_on_floor() == true:
			$AnimatedSprite.set_animation("run")
			play_loop($SoundEffect/Run)
		elif abs(motion.x) == 0 and is_on_floor() == true:
			$AnimatedSprite.set_animation("stop")
			$SoundEffect/Run.stop()
			
			
	if on_floor == false and is_on_floor() == true:
		$SoundEffect/Jumpin1.play()
	if is_on_floor() == false:
		$SoundEffect/Run.stop()
		
			
	# Set persistent variable
	on_floor = is_on_floor()
			
			
func play_loop(audio):
	if audio.is_playing() == false:
		audio.play()
		

func _on_AnimatedSprite_animation_finished():
	var current_anim = $AnimatedSprite.get_animation()
	
	if current_anim == "jump_in" or current_anim == "jump_attack":
		$AnimatedSprite.set_animation("jump_air")
	elif current_anim == "run_start":
		$AnimatedSprite.set_animation("run")
		play_loop($SoundEffect/Run)
	elif current_anim == "jump_air":
		pass
	else:
		$AnimatedSprite.set_animation("stop")
		
