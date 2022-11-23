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
