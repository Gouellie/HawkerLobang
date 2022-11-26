extends State

var _business_hours : BusinessHours

var is_in_business_hour : bool

var queue_manager : QueueManager

const idle_node_path : String = "Rented/Open/Idle"
const cooking_node_path : String = "Rented/Open/Cooking"


func _ready() -> void:
	yield(owner, "ready")
	queue_manager = owner.queue_manager


func enter(_msg: Dictionary = {}) -> void:
	queue_manager.set_stall_open(true)	
	owner.sprite_stall.frame = 1
	owner.label_state.text = "open"
	_state_machine.transition_to(idle_node_path)
		

func update_business_state(date_time : DateTime, init : bool) -> bool:
	return _parent.update_business_state(date_time, init)


func set_to_idle() -> void:
	_state_machine.transition_to(idle_node_path)


func serve_patron(patron : Patron) -> void:
	_state_machine.transition_to(cooking_node_path, {"patron" : patron})
