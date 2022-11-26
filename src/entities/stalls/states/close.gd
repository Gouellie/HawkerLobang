extends State

var queue_manager : QueueManager

func _ready() -> void:
	yield(owner, "ready")
	queue_manager = owner.queue_manager
	

func enter(_msg: Dictionary = {}) -> void:
	owner.label_state.text = "close"
	queue_manager.set_stall_open(false)	
	owner.sprite_stall.frame = 2


func on_time_ellapsed(date_time : DateTime) -> void:
	_parent.update_business_state(date_time, false)
