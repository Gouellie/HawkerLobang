extends State

var stall_creator_preload = preload("res://src/UI/stall_creator.tscn")

func enter(_msg: Dictionary = {}) -> void:
	owner.stall_shape.color = Color.gray


func select(_event : InputEventMouse) -> void:
	var selection = yield(_select_stall(), "completed")
	if selection :
		_open_stall(selection)


func _select_stall() -> String:
	var picker = stall_creator_preload.instance()
	get_tree().root.add_child(picker)
	var selection = yield(picker, "selection_made")
	return selection
	

func _open_stall(selection : Dictionary)-> void:
	_state_machine.transition_to("Open")
	owner.resource = Resources.STALLS[selection["stall"]]
	owner.stall_name = selection["name"]
