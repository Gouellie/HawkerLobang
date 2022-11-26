extends State

var queue_manager : QueueManager

func _ready() -> void:
	yield(owner, "ready")
	queue_manager = owner.queue_manager

func enter(_msg: Dictionary = {}) -> void:
	queue_manager.set_stall_open(false)
	owner.label_state.text = "vacant"
	if owner.sprite_stall is Sprite:
		owner.sprite_stall.frame = 0


func select(_event : InputEventMouse) -> void:
	pass
	

func _open_stall(selection : Dictionary)-> void:
	_state_machine.transition_to("Open")
	owner.resource = Resources.STALLS[selection["stall"]]
	owner.stall_name = selection["name"]
