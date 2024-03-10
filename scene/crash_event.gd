extends GameEvent

func _on_body_entered(body):
	super._on_body_entered(body)
	player.shake()
	player.handheld.toggle_screen(false)
	player.handheld.morse_timer.wait_time = 0.2
	player.handheld.dot_sfx.pitch_scale = 0.7
	player.handheld.dash_sfx.pitch_scale = 0.7
	player.flashlight.visible = false
	player.can_up = false
	player.can_move = false
	$Timer.start()


func _on_timer_timeout():
	player.handheld.toggle_screen(true)
	player.flashlight.visible = true
	player.can_move = true
	player.handheld.clear_text()
	player.handheld.add_to_stack("CQ CQ CQ disturbance on the wire")
