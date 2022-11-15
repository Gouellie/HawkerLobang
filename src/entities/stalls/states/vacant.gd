extends State

func enter(_msg: Dictionary = {}) -> void:
	owner.stall_shape.color = Color.gray


func select(_event : InputEventMouse) -> void:
	pass
	

func _open_stall(selection : Dictionary)-> void:
	_state_machine.transition_to("Open")
	owner.resource = Resources.STALLS[selection["stall"]]
	owner.stall_name = selection["name"]
