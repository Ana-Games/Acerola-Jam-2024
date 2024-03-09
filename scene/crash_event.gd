extends GameEvent

func _on_body_entered(body):
	super._on_body_entered(body)
	player.handheld.toggle_screen(false)
	player.flashlight.visible = false
	player.handheld.get_node("Offset").rotation_degrees.z = 45
	player.can_up = false
	$Timer.start()


func _on_timer_timeout():
	player.handheld.toggle_screen(true)
	player.flashlight.visible = true
	player.handheld.clear_text()
	player.handheld.add_to_stack("CQ CQ CQ disturbance on the wire")
