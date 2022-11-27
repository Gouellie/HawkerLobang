extends State

var exit = Node2D

func enter(_msg: Dictionary = {}) -> void:
	if owner.label_state :
		owner.label_state.text = "leaving"
	exit = Global.entrance_manager.get_exit()
	var unspawn_pos = exit.global_position
	_parent.on_speed_changed(Global.current_speed)
	_parent.set_navigation_position(unspawn_pos)


func on_time_ellapsed(time : DateTime) -> void:
	_parent.on_time_ellapsed(time)


func on_speed_changed(speed : int) -> void:
	_parent.on_speed_changed(speed)


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)


func character_target_reached() -> void:
	Events.emit_signal("patron_leaving", owner)


func on_Area2D_body_entered(body: Node2D) -> void:
	if body == exit:
		Events.emit_signal("patron_leaving", owner)
