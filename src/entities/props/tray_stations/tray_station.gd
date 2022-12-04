extends Entity


func serialize() -> Dictionary:
	return .serialize()


func deserialize(data : Dictionary) -> void:
	.deserialize(data)


func post_deserialized() -> void:
	pass


func register() -> void:
	pass


func cleanup() -> void:
	pass
