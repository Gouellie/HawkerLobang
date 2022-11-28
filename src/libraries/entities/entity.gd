extends Node2D

class_name Entity

export (String) var scene_key

func serialize() -> Dictionary:
	return {
		"or" : rotation_degrees,		
	}


func deserialize(data : Dictionary) -> void:
	if data and data.has("or"):
		rotation_degrees = data["or"]


func track_entity() -> void:
	pass


# override on subclass if the entity needs to register to a manager
func register() -> void:
	pass


# invoked by entity_tracker before entity queue_freed
func cleanup() -> void:
	pass
