extends Area2D


# Declare member variables here. Examples:
export var power_max = 5
export var power_min = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta):


func _on_Area2D_body_entered(body):
	print("slash ", body.name, " by ", rand_range(power_min, power_max), " dmg")
