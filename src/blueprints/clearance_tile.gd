extends Node2D

class_name ClearanceTile


export (PoolIntArray) var allowed_tiles
onready var clearance_shape = $Clearance_Shape


func set_has_clearance(has_clearance : bool) -> void:
	if has_clearance:
		clearance_shape.color = Color(0.0,1.0,0.0,0.25)
	else:
		clearance_shape.color = Color(1.0,0.0,0.0,0.25)
