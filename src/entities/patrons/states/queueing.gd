extends State

var queuing_at_stall : Stall

const TIME_MAX : int = 60
var time_in_queue : int = 0
var time_in_queue_since_last_update : int = 0
var patron_in_queue : bool

func enter(msg: Dictionary = {}) -> void:
	if owner.label_state :
		owner.label_state.text = "queueing"	
	patron_in_queue = false
	if msg.has("stall") and msg["stall"] is Stall :
		var stall = msg["stall"]
		if not stall.is_open_for_business:
			break_queue()
			return
		var result = stall.queue_manager.patron_join_queue(owner)
		if not result["success"]:
			break_queue()
			return
		_parent.set_navigation_position(result["pos"])
		queuing_at_stall = stall
		time_in_queue = 0
		time_in_queue_since_last_update = 0
	else:
		break_queue()


func exit() -> void:
	queuing_at_stall = null


func _on_entity_selected(entity : Entity) -> void:
	if not owner.selected :
		return
	if entity is Stall and not entity.is_stall_vacant:
		break_queue()
		_parent.set_navigation_position(entity.queue_position)


func on_time_ellapsed(time : DateTime) -> void:
	if not is_instance_valid(queuing_at_stall) :
		break_queue()
		return
	if not queuing_at_stall.is_open_for_business:
		break_queue()
	_parent.on_time_ellapsed(time)
	time_in_queue += 1
	time_in_queue_since_last_update += 1
	if patron_in_queue:
		owner.label_state.text = "queueing for : %02d minutes" % time_in_queue
	else:
		owner.label_state.text = "queueing : moving to position"
	if time_in_queue_since_last_update >= TIME_MAX:
		break_queue()


func on_speed_changed(speed : int) -> void:
	_parent.set_navigation_speed(speed)


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)


func character_target_reached() -> void:
	if not is_instance_valid(queuing_at_stall) :
		break_queue()
	patron_in_queue = true


func is_patron_in_queue() -> bool:
	return patron_in_queue


func break_queue() -> void:
	if is_instance_valid(queuing_at_stall) :
		queuing_at_stall.queue_manager.patron_break_queue(self)
	queuing_at_stall = null
	_state_machine.transition_to("Moving/Browsing")


func taking_patron_order() -> void:
	_state_machine.transition_to("Moving/Ordering", {
		"stall" : queuing_at_stall
	})


func update_position_in_queue(pos : Vector2) -> void:
	_parent.set_navigation_position(pos)
	time_in_queue_since_last_update = 0
	patron_in_queue = false


func leave() -> void:
	if is_instance_valid(queuing_at_stall) :
		queuing_at_stall.queue_manager.patron_break_queue(self)
		queuing_at_stall = null
	_state_machine.transition_to("Moving/Leaving")
