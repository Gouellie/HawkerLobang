extends Blueprint
class_name BlueprintStall

onready var _invalid : Sprite = $Invalid
onready var _clearances := $Clearances
onready var _clearance_positions := $Clearances/ClearancesPositions


func show_debug(p_show : bool) -> void:
	_clearances.visible = p_show


func set_valid(valid : bool) -> void:
	_invalid.visible = not valid


func _get_clearance_positions() -> Array:
	var array = Array()
	for clearance in _clearance_positions.get_children():
		if clearance is ClearanceTile:
			array.push_back(clearance)
	return array
