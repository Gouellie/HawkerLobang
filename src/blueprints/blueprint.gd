extends Node2D
class_name Blueprint

export (String, MULTILINE) var description := ""
export (PackedScene) var entity_scene

onready var _outline := $StallShape_Outline
onready var _owner := owner


func _ready() -> void:
	_outline.visible = false
	

func set_selected(selected : bool) -> void:
	_outline.visible = selected	


func place_entity(in_owner : Node2D) -> void:
	var new_entity = entity_scene.instance() as Node2D
	new_entity.position = position
	in_owner.add_child(new_entity)
