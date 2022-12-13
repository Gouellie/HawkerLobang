extends Node2D
class_name Entrance

signal entrance_close(entrance,is_closed)

export var is_closed : bool = false
var expansion_mode_enabled : bool = false
onready var closed_sprite := $Closed

func _ready() -> void:
	Log.log_error(Events.connect("expansion_mode_changed", self, "on_expansion_mode_changed"))
	if is_closed:
		set_is_closed(true)


func cancel_close() -> void:
	is_closed = false
	closed_sprite.visible = is_closed


func _on_Area2D_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if expansion_mode_enabled:
		return
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_click"):
			set_is_closed(not is_closed)


func set_is_closed(closed : bool) -> void:
	is_closed = closed
	closed_sprite.visible = closed
	emit_signal("entrance_close", self, closed)


func on_expansion_mode_changed(value : bool) -> void:
	expansion_mode_enabled = value
