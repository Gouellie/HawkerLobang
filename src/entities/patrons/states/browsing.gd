extends State

var time_with_no_stall : int = 0
var visited_stall = []

func enter(_msg: Dictionary = {}) -> void:
	if owner.label_state :
		owner.label_state.text = "browsing"


func _on_entity_selected(entity : Entity) -> void:
	if not owner.selected :
		return
	if entity is Stall and not entity.is_stall_vacant:
		_stall_found(entity)


func on_time_ellapsed(time : DateTime) -> void:
	_parent.on_time_ellapsed(time)
	_browse_for_stall()


func on_speed_changed(speed : int) -> void:
	_parent.set_navigation_speed(speed)


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)


func _browse_for_stall() -> void:
	var opened_stalls = Global.stall_manager.get_open_stall()
	if opened_stalls.size() < 1:
		time_with_no_stall += 1
		if time_with_no_stall >= 3:
			_leave()
		return
	var stall : Stall
	var init = true
	while init or visited_stall.has(stall):
		init = false
		if opened_stalls.size() < 1:
			_leave()
			return
		var r_index = randi() % opened_stalls.size()
		stall = opened_stalls.pop_at(r_index)
	time_with_no_stall = 0
	_stall_found(stall)


func _leave() -> void:
	_state_machine.transition_to("Moving/Leaving")


func _stall_found(stall : Stall) -> void:
	visited_stall.push_back(stall)		
	_state_machine.transition_to("Moving/VisitingStall", {
		"stall" : stall
	})	
