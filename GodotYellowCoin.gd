extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if has_overlapping_bodies() == true:
		queue_free()
		LevelManager.load_next_level()
		
	
 
