extends Node2D

class_name Entity

export (String) var scene_key


func serialize() -> Dictionary:
	return {
		"or" : rotation_degrees,
	}


# called before the node is added to the tree
func deserialize(data : Dictionary) -> void:
	if data and data.has("or"):
		rotation_degrees = data["or"]


# called after the node is added to the tree, if deserialize has been called
func post_deserialized() -> void:
	pass


# override on subclass if the entity needs to register to a manager
func register() -> void:
	pass


# invoked by entity_tracker before entity queue_freed
func cleanup() -> void:
	pass
	
	
# override if entity can be tracked by the camera when selected
func can_track_entity() -> bool:
	return false
	

# override if entity should prompt the toolbox to open when selected
func open_toolbox() -> bool:
	return false
