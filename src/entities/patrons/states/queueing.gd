extends State

var queuing_at_stall : Stall

var entered_queue_at : DateTime
var time_in_queue : DateTime
var patron_in_queue : bool

func enter(msg: Dictionary = {}) -> void:
	if owner.label_state :
		owner.label_state.text = "queueing"	
	Log.log_error(Events.connect("entity_debug_selected", self, "_on_entity_selected"), "queueing.gd")
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
		entered_queue_at = Global.current_datetime
		time_in_queue = DateTime.new()
	else:
		break_queue()


func exit() -> void:
	entered_queue_at = null
	time_in_queue = null
	queuing_at_stall = null
	Events.disconnect("entity_debug_selected", self, "_on_entity_selected")


func _on_entity_selected(entity : Entity) -> void:
	if not owner.selected :
		return
	if entity is Stall and not entity.is_stall_vacant:
		break_queue()
		_parent.set_navigation_position(entity.queue_position)


func on_time_ellapsed(time : DateTime) -> void:
	_parent.on_time_ellapsed(time)
	if patron_in_queue:
		time_in_queue.increment()
		owner.label_state.text = "queueing for : %02d:%02d" % [time_in_queue.hour, time_in_queue.minute]
	else:
		owner.label_state.text = "queueing : moving to position"


func on_speed_changed(speed : int) -> void:
	_parent.on_speed_changed(speed)


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)


func character_target_reached() -> void:
	if not is_instance_valid(queuing_at_stall) :
		break_queue()
	patron_in_queue = true


func is_patron_in_queue() -> bool:
	return patron_in_queue


func break_queue() -> void:
	if queuing_at_stall:
		queuing_at_stall.queue_manager.patron_break_queue(self)
	queuing_at_stall = null
	_state_machine.transition_to("Moving/Browsing")


func taking_patron_order() -> void:
	_state_machine.transition_to("Moving/Ordering", {
		"stall" : queuing_at_stall
	})


func update_position_in_queue(pos : Vector2) -> void:
	_parent.set_navigation_position(pos)
	patron_in_queue = false
