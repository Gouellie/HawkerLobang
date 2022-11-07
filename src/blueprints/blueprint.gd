extends Node2D
class_name Blueprint

export (String, MULTILINE) var description := ""
export (PackedScene) var entity_scene

var is_drag := false

onready var _origin := position


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_action_pressed("select"):
		Events.emit_signal("placement_requested", entity_scene, event.position)
		position = _origin
