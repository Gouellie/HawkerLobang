extends State

func enter(_msg: Dictionary = {}) -> void:
	Log.log_error(Events.connect("entity_debug_selected", self, "_on_entity_selected"), "browsing.gd")


func exit() -> void:
	Events.disconnect("entity_debug_selected", self, "_on_entity_selected")


func _on_entity_selected(entity : Entity) -> void:
	if not owner.selected :
		return
	if entity is Stall and not entity.is_stall_vacant:
		_parent.set_navigation_position(entity.queue_position)


func on_time_ellapsed(time : DateTime) -> void:
	_parent.on_time_ellapsed(time)


func on_speed_changed(speed : int) -> void:
	_parent.on_speed_changed(speed)


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)


func character_target_reached() -> void:
	if Global.entity_tracker:
		var opened_stalls = []
		var entities = Global.entity_tracker.entities.values()
		for entity in entities:
			if entity is Stall and not entity.is_stall_vacant:
				opened_stalls.push_back(entity)
		if opened_stalls.size() < 1:
			return
		var r_index = randi() % opened_stalls.size()
		var stall = opened_stalls[r_index]
		yield(get_tree().create_timer(1.0), "timeout")
		_visit_stall(stall)
		

func _visit_stall(stall : Stall) -> void:
	if stall :
		_parent.set_navigation_position(stall.queue_position)
