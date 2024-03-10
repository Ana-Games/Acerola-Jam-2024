extends Node
class_name GameManager

var scene = ResourceLoader.load("res://game.tscn") as PackedScene
var current_scene : Node3D

func start_game():
	var new = scene.instantiate()
	$Control.queue_free()
	current_scene = new
	add_child(new)

func end_game():
	current_scene.queue_free()
	get_tree().quit()
	
func _process(delta):
	if not is_instance_valid(current_scene):
		if Input.is_action_just_pressed("interact"):
			start_game()
