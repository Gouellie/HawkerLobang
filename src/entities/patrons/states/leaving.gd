extends State


func enter(_msg: Dictionary = {}) -> void:
	if owner.label_state :
		owner.label_state.text = "leaving"
	var unspawn_pos = Global.entrance_manager.get_entrance()
	_parent.set_navigation_position(unspawn_pos)


func on_time_ellapsed(time : DateTime) -> void:
	_parent.on_time_ellapsed(time)


func on_speed_changed(speed : int) -> void:
	_parent.on_speed_changed(speed)


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)


func character_target_reached() -> void:
	Events.emit_signal("patron_leaving", owner)
