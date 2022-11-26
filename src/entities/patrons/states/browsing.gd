extends State

var time_with_no_stall : int = 0

func enter(_msg: Dictionary = {}) -> void:
	if owner.label_state :
		owner.label_state.text = "browsing"
	Log.log_error(Events.connect("entity_debug_selected", self, "_on_entity_selected"), "browsing.gd")


func exit() -> void:
	Events.disconnect("entity_debug_selected", self, "_on_entity_selected")


func _on_entity_selected(entity : Entity) -> void:
	if not owner.selected :
		return
	if entity is Stall and not entity.is_stall_vacant:
		_stall_found(entity)


func on_time_ellapsed(time : DateTime) -> void:
	_parent.on_time_ellapsed(time)
	_browse_for_stall()


func on_speed_changed(speed : int) -> void:
	_parent.on_speed_changed(speed)


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)


func _browse_for_stall() -> void:
	if Global.entity_tracker:
		var opened_stalls = []
		var entities = Global.entity_tracker.entities.values()
		
		for entity in entities:
			if entity is Stall and entity.is_open_for_business:
				opened_stalls.push_back(entity)

		if opened_stalls.size() < 1:
			time_with_no_stall += 1
			if time_with_no_stall >= 3:
				_leave()
			return
		else:
			time_with_no_stall = 0
		var r_index = randi() % opened_stalls.size()
		var stall = opened_stalls[r_index]
		_stall_found(stall)

func _leave() -> void:
	_state_machine.transition_to("Moving/Leaving")


func _stall_found(stall : Stall) -> void:
	if not stall :
		return
	if not stall.is_open_for_business:
		return
	_state_machine.transition_to("Moving/VisitingStall", {
		"stall" : stall
	})	
