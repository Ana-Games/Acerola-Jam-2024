extends CSGCylinder3D

func _process(delta):
	position.y = lerp(position.y,0.0, delta *5)
