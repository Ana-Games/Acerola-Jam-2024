extends GameEvent

func _on_body_entered(body):
	player.handheld.get_node("Tap").volume_db = -20.0
	super._on_body_entered(body)
	player.spawn_spider()
