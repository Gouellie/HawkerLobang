extends State

var queue_manager : QueueManager

func enter(_msg: Dictionary = {}) -> void:
	owner.label_state.text = "open/idle"
	queue_manager = _parent.queue_manager
	
		
func exit() -> void:
	pass
	

func on_time_ellapsed(date_time : DateTime) -> void:
	if not _parent.update_business_state(date_time, false) :
		return
	if not queue_manager:
		return
	var patron = queue_manager.get_next_patron()
	if patron is Patron:
		_parent.serve_patron(patron)
