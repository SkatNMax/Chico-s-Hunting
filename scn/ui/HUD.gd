extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Player_health_depleted():
	if $Border/HealthBar.rect_size.x >= 16:
		$Border/HealthBar.rect_size.x -= 16
	if $Border/HealthBar.rect_size.x == 0:
		get_tree().change_scene("res://scn/ui/TitleScreen.tscn")


func _on_Player_haelth_gained():
	if $Border/HealthBar.rect_size.x <= 48:
		$Border/HealthBar.rect_size.x += 16
