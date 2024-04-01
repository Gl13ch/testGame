extends Node

# List of levels
var levels = [
	"res://LevelZero.tscn",
	"res://LevelOne.tscn",
	"res://LevelTwo.tscn",
	"res://LevelThree.tscn",
	"res://LevelFour.tscn",
	# Add as many levels as you have
]

var current_level_index = 0

signal level_loaded(index)

# Called when the node enters the scene tree for the first time.
#func _ready():
	# Optionally, load the first level at game start
	#load_level(current_level_index)

# Loads a level by its index
func load_level(index):
	if index >= 0 and index < levels.size():
		var level_path = levels[index]
		# Update current level index
		current_level_index = index
		# Actual scene loading
		#var scene = load(level_path).instantiate()
		get_tree().change_scene_to_file(level_path)
		# Emit signal to notify other parts of the game
		emit_signal("level_loaded", current_level_index)
		# Optionally, remove the previous level from the scene tree
		# This assumes there is a naming convention or way to identify the previous level node
	else:
		print("End of levels or invalid level index.")
		# Handle end of levels or invalid index, e.g., loop to start or show game over
		# loop_to_start() or show_game_over()

func load_next_level():
	load_level(current_level_index + 1)

# Example function to loop back to the first level
func loop_to_start():
	load_level(0)

# Example function to show game over screen or logic
func show_game_over():
	print("Game Over! Restarting...")
	load_level(0)
