extends Node2D


# Declare member variables here
export var fishes_tiles_ids = [4,5]
export var fishes_rate = 30 # Number of spawn per minutes (nb/min)
export var fishes_count = 20 # Count per 100 horizontales tiles (nb/100 tiles)
export var fishes_stats = {
	"trout" : {
		"quality" : 1,
		"proba" : 100},
		
	"red_trout" : {
		"quality" : 0.25,
		"proba" : 10}
	}
var fishes_spawn = []
var fishes_instances = []
var proba_cumul = []
var proba_sum = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Load player character
	var player = load("res://scn/instances/chico.tscn")
	player = player.instance()
	player.position = $StartPoint.position
	add_child(player)
	
	# Loop on tiles ids
	for i in fishes_tiles_ids:
		
		# Transpose local tilemap coordinate to global coordinate
		for p in $TileMap.get_used_cells_by_id(i):
			p = $TileMap.map_to_world(p)
			p = $TileMap.to_global(p)
			p += $TileMap.cell_size/2
			fishes_spawn.append(p)
			
	# Preload the fishes scenes
	for i in fishes_stats:
		i = load("res://scn/instances/" + i + ".tscn")
		fishes_instances.append(i)
	print(fishes_instances)
	
	# Build list of probability spawn	
	for fish in fishes_stats:
		proba_sum += fishes_stats[fish]["proba"]
		proba_cumul.append(proba_sum)
	
	# Setup timer node
	$SpawnTimer.autostart = true
	$SpawnTimer.wait_time = 60.0/fishes_rate
	$SpawnTimer.one_shot = false
	
	# Align camera
	reparent($Camera2D, $Chico/CamTarget)
	#$Camera2D.align()
	
	
	# Print tree
	print_tree_pretty()

	
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SpawnTimer_timeout():
	if len(fishes_stats) > 0:
		var spawn_index = randi() % len(fishes_spawn)
		var proba_rand = randi() % proba_sum
		var fish_index = 0
		
		# Loop on cumul proba list
		for p in proba_cumul:
			
			# If the random pick is lower ther proba break the loop and save the fish_index
			if proba_rand < p:
				break
			fish_index += 1
			
		var new_fish = fishes_instances[fish_index]
		new_fish = new_fish.instance()
		new_fish.position = fishes_spawn[spawn_index]
		new_fish.scale = Vector2(0.5,0.5)
		$FishesNavigation2D.add_child(new_fish)
		#new_fish.position = fishes_tiles[spawn_index]
		
		print(new_fish.name, " at : ", new_fish.position)
	else:
		print("no fishes stat")
		
		
func reparent(child: Node, new_parent: Node):
	var old_parent = child.get_parent()
	old_parent.remove_child(child)
	new_parent.add_child(child)
	
