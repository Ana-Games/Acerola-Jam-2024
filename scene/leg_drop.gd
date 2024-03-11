extends GameEvent

func _on_body_entered(body):
	super._on_body_entered(body)
	player.drop_leg()
