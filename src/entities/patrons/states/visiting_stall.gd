extends State

var selected_stall : Stall

func enter(msg: Dictionary = {}) -> void:
	if owner.label_state :
		owner.label_state.text = "visiting stall"
	if msg.has("stall") and msg["stall"] is Stall :
		_visit_stall(msg["stall"])
	

func _on_entity_selected(entity : Entity) -> void:
	if not owner.selected :
		return
	if entity is Stall and not entity.is_stall_vacant:
		_visit_stall(entity)


func on_time_ellapsed(time : DateTime) -> void:
	_parent.on_time_ellapsed(time)
	if not is_instance_valid(selected_stall) or not selected_stall.is_open_for_business:
		_resume_browsing()


func on_speed_changed(speed : int) -> void:
	_parent.set_navigation_speed(speed)


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)


func on_Area2D_body_entered(body: Node2D) -> void:
	if body == selected_stall:
		_enter_queue()


func character_target_reached() -> void:
	_enter_queue()


func _resume_browsing() -> void:
	_state_machine.transition_to("Moving/Browsing")


func _enter_queue() -> void:
	if is_instance_valid(selected_stall) and not selected_stall.is_stall_vacant:
		if selected_stall.queue_manager.can_join_queue():
			_state_machine.transition_to("Moving/Queueing", {
				"stall" : selected_stall
			})
			return
	_resume_browsing()


func _visit_stall(stall : Stall) -> void:
	if not stall :
		return
	selected_stall = stall		
	_parent.set_navigation_position(stall.queue_position)
