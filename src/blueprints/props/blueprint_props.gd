extends Blueprint
class_name BlueprintProp

onready var skin : Sprite = $Sprite
onready var _invalid : Sprite = $Invalid


func set_selected(_selected : bool) -> void:
	pass


func show_debug(_show : bool) -> void:
	pass


func set_valid(valid : bool) -> void:
	_invalid.visible = not valid


func _get_clearance_positions() -> Array:
	var array = Array()
	return array	
