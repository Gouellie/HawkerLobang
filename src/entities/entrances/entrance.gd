extends Node2D
class_name Entrance

signal entrance_close(entrance,is_closed)

var is_closed : bool = false
onready var closed_sprite := $Closed


func _on_Area2D_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_click"):
			is_closed = not is_closed
			closed_sprite.visible = is_closed
			emit_signal("entrance_close", self, is_closed)
