extends Area2D


# Declare member variables here. Examples:
var ending = false
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ending == true:
		if $Particles2D.emitting == false:
			queue_free()
			print(name, " leave the scene")


func _on_Champi_body_entered(body):
	$Sprite.visible = false
	$Collision.disabled = true
	$Particles2D.emitting = true
	ending = true
	
