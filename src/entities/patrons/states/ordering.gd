extends State

var stall : Stall

func enter(msg: Dictionary = {}) -> void:
	if owner.label_state :
		owner.label_state.text = "ordering"	
	Log.log_error(Events.connect("entity_debug_selected", self, "_on_entity_selected"), "queueing.gd")
	if msg.has("stall") and msg["stall"] is Stall :
		stall = msg["stall"]
		if stall:
			_parent.set_navigation_position(stall.counter_position)


func exit() -> void:
	Events.disconnect("entity_debug_selected", self, "_on_entity_selected")


func on_time_ellapsed(time : DateTime) -> void:
	_parent.on_time_ellapsed(time)
	if not stall.is_open_for_business:
		resume_browse()

	
func resume_browse() -> void:
	_state_machine.transition_to("Moving/Browsing")
	
	
func on_speed_changed(speed : int) -> void:
	_parent.on_speed_changed(speed)


func serving_patron() -> void:
	_state_machine.transition_to("Moving/Leaving")
	

func physics_process(delta: float) -> void:
	_parent.physics_process(delta)
