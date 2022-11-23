extends Entity

class_name Table

# https://godotengine.org/qa/26104/how-can-you-get-navigation2d-recognize-updates-the-nav-mesh


func _ready() -> void:
	pass
	

func serialize() -> Dictionary:
	return .serialize()


func deserialize(data : Dictionary) -> void:
	.deserialize(data)

