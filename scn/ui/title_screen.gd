extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Setup animated image
	var length = 24
	$TextureRect.texture = AnimatedTexture.new()
	$TextureRect.texture.fps = 30
	$TextureRect.texture.frames = length
	
	
	for i in range(0,length):
		var frame = load("res://img/characters/chico/stop/stop00" + "%02d" % (i+1) + ".png")
		
		$TextureRect.texture.set_frame_texture(i, frame)
		$TextureRect.texture.set_frame_delay(i, 0)
		
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Start_pressed():
	get_tree().change_scene("res://scn/levels/terra_verde.tscn")


func _on_Quit_pressed():
	get_tree().quit()
