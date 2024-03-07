extends Area3D
class_name GameEvent

@onready var player = get_tree().get_first_node_in_group("player") as Player
@export var message = "" as String
var complete = false as bool
signal on_enter

func _on_body_entered(body):
	if not complete:
		on_enter.emit()
		complete = true
		set_deferred("monitoring",false)
		if message != "": player.handheld.clear_text()
		player.handheld.add_to_stack(message)
