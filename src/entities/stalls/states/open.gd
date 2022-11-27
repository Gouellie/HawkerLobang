extends State

const IDLE : String = "Rented/Open/Idle"

var is_in_business_hour : bool

var queue_manager : QueueManager
var _business_hours : BusinessHours


func _ready() -> void:
	yield(owner, "ready")
	queue_manager = owner.queue_manager


func enter(_msg: Dictionary = {}) -> void:
	owner.sprite_stall.frame = 1
	owner.label_state.text = "open"
	queue_manager.set_stall_open(true)	
	_state_machine.transition_to(IDLE)


func update_business_state(date_time : DateTime, init : bool) -> bool:
	return _parent.update_business_state(date_time, init)
