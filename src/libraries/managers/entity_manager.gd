extends Node2D
class_name EntityManager

func _ready() -> void:
	Log.log_error(Events.connect("placement_requested", self, "_on_placement_requested"), "entity_manager.gd")


func _on_placement_requested(entity_scene : PackedScene, position : Vector2) -> void:
	var new_entity = entity_scene.instance() as Node2D
	new_entity.position = position
	add_child(new_entity)
