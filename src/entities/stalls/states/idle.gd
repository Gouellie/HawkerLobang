extends State

const COOKING : String = "Rented/Open/Cooking"

var queue_manager : QueueManager


func enter(_msg: Dictionary = {}) -> void:
	owner.label_state.text = "open/idle"
	queue_manager = _parent.queue_manager


func exit() -> void:
	pass


func on_time_ellapsed(date_time : DateTime) -> void:
	if not _parent.update_business_state(date_time, false) :
		# stall closes on the next tick
		return
	var patron = queue_manager.get_next_patron()
	if patron is Patron:
		_serve_patron(patron)


func _serve_patron(patron : Patron) -> void:
	_state_machine.transition_to(COOKING, {"patron" : patron})
