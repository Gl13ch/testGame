extends Area2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if has_overlapping_bodies() == true:
		for x in get_overlapping_bodies():
			if x.is_in_group("RedEnemy"):
				if x.direction == 1:
					x.direction = -1
