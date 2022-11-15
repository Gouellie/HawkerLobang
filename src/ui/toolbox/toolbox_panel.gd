extends Control
class_name ToolboxPanel

var selected_entity : Entity

# load setup, return if panel should be active or not
func load_entity(entity : Entity) -> bool:
	selected_entity = entity
	return false


func unload_entity() -> void:
	selected_entity = null
