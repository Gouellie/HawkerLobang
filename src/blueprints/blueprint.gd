extends BlueprintBase
class_name Blueprint

export (String, MULTILINE) var description := ""
export (PackedScene) var entity_scene

var clearance_positions : Array setget ,_get_clearance_positions
var facing_rotation : int = 0

onready var _outline := $StallShape_Outline
onready var _invalid : Sprite = $Invalid
onready var _facing := $Facing
onready var _clearance_positions := $Facing/ClearancesPositions


func _ready() -> void:
	_outline.visible = false


func set_selected(selected : bool) -> void:
	_outline.visible = selected	


func show_debug(p_show : bool) -> void:
	_facing.visible = p_show


func set_valid(valid : bool) -> void:
	_invalid.visible = not valid


func set_facing(rotation_in_degrees : int) -> void:
	facing_rotation = rotation_in_degrees
	_facing.rotation_degrees = rotation_in_degrees
	

func _get_clearance_positions() -> Array:
	var array = Array()
	for clearance in _clearance_positions.get_children():
		if clearance is ClearanceTile:
			array.push_back(clearance)
	return array

