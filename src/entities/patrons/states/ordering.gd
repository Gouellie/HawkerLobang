extends State

var stall : Stall


func enter(msg: Dictionary = {}) -> void:
	if owner.label_state :
		owner.label_state.text = "ordering"	
	if msg.has("stall") and msg["stall"] is Stall :
		stall = msg["stall"]
		if stall:
			_parent.set_navigation_position(stall.counter_position)


func exit() -> void:
	pass


func on_time_ellapsed(time : DateTime) -> void:
	_parent.on_time_ellapsed(time)
	if not is_instance_valid(stall) or not stall.is_open_for_business:
		resume_browse()

	
func resume_browse() -> void:
	_state_machine.transition_to("Moving/Browsing")
	
	
func on_speed_changed(speed : int) -> void:
	_parent.set_navigation_speed(speed)


func serving_patron() -> void:
	owner.skin_tray.visible = true
	if owner.is_in_patron_group:
		_state_machine.transition_to("Moving/MovingToTable")
	else:
		_state_machine.transition_to("Moving/ChopeTable")


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)
