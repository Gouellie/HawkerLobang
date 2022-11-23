extends BlueprintBase
class_name Blueprint

export (String, MULTILINE) var description := ""
export (PackedScene) var entity_scene
export (bool) var is_prop

var clearance_positions : Array setget ,_get_clearance_positions


func set_selected(_selected : bool) -> void:
	pass


func show_debug(_show : bool) -> void:
	pass


func set_valid(_valid : bool) -> void:
	pass


func set_facing(rotation_in_degrees : int) -> void:
	rotation_degrees = rotation_in_degrees
	

func _get_clearance_positions() -> Array:
	var array = Array()
	return array	
