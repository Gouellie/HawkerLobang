class_name EntityTracker
extends Reference

var entities := {}


func place_entity(entity, cellv: Vector2) -> void:
	if entities.has(cellv):
		return
	entities[cellv] = entity


func remove_entity(cellv: Vector2) -> void:
	if entities.has(cellv):
		var entity = entities[cellv]
		var _result := entities.erase(cellv)
		entity.queue_free()


func is_cell_occupied(cellv: Vector2) -> bool:
	return entities.has(cellv)


func get_entity_at(cellv: Vector2) -> Node2D:
	if entities.has(cellv):
		return entities[cellv]
	else:
		return null
