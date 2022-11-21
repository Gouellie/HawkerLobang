extends TileMap
class_name EntityManager

export (NodePath) var ground_path
var _ground: TileMap

var tile_offset : Vector2


const EMPTY_TILE_INDEX : int = 0
const STALL_TILE_INDEX : int = 1
const STALL_FRONT_TILE_INDEX : int = 5

var _tracker: EntityTracker
var _blueprint : BlueprintBase
var _placeable_blueprint : bool
var _valid_eraser : bool

func _ready() -> void:
	_ground = get_node(ground_path) as TileMap
	_tracker = EntityTracker.new()
	tile_offset = _ground.cell_size / 2
	Log.log_error(Events.connect("blueprint_selected", self, "_on_blueprint_selected"), "entity_manager.gd")
	_load()


func _process(_delta: float) -> void:
	if _blueprint:
		_move_blueprint(get_global_mouse_position())


func _register_children() -> void:
	for child in get_children():
		if not child is Node2D:
			continue
		var cellv = _ground.world_to_map(child.global_position)
		_mark_ground(cellv, STALL_TILE_INDEX)
		_tracker.place_entity(child, cellv)
		if not child is Stall:
			continue
		var front_cellv = _ground.world_to_map(child.queue_position)		
		_mark_ground(front_cellv, STALL_FRONT_TILE_INDEX, child.orientation)


func _on_blueprint_selected(sender : Object) -> void:
	if _blueprint:
		_blueprint.queue_free()
		_blueprint = null
		_placeable_blueprint = false
		_valid_eraser = false
	if sender is BlueprintPanel:
		if sender.blueprint_scene:
			_blueprint = sender.blueprint_scene.instance() as BlueprintBase
			add_child(_blueprint)
			_blueprint.show_debug(true)
	_ground.visible = _blueprint != null


func _mark_ground(cellv: Vector2, tile_index : int, rotation_in_degrees : int = 0) -> void:
	var flip_x = false
	var flip_y = false
	var transpose = false
	if rotation_in_degrees == Enums.ORIENTATION.DOWN:
		flip_x = true
		transpose = true	
	elif rotation_in_degrees == Enums.ORIENTATION.LEFT:
		flip_x = true
		flip_y = true
	elif rotation_in_degrees == Enums.ORIENTATION.UP:
		flip_y = true
		transpose = true
	_ground.set_cellv(cellv, tile_index, flip_x, flip_y, transpose)


func _move_blueprint(mouse_position: Vector2) -> void:
	var cellv = _ground.world_to_map(mouse_position)
	var snap_position = _ground.map_to_world(cellv)
	_blueprint.position = snap_position + tile_offset
	if _blueprint is Blueprint:
		_validate_blueprint_position(cellv)
	elif _blueprint is BlueprintEraser:
		_validate_eraser_position(cellv)


func _validate_blueprint_position(cellv: Vector2) -> void:
	var tile_index = _ground.get_cellv(cellv)
	_placeable_blueprint = tile_index == EMPTY_TILE_INDEX
	for clearance_tile in _blueprint.clearance_positions:
		if not clearance_tile is ClearanceTile:
			continue
		_placeable_blueprint =  _check_clearance(clearance_tile) and _placeable_blueprint
	_blueprint.set_valid(_placeable_blueprint)


func _check_clearance(clearance_tile : ClearanceTile) -> bool:
		var cellv = _ground.world_to_map(clearance_tile.global_position)
		var tile_index_facing = _ground.get_cellv(cellv)
		var has_clearance = clearance_tile.allowed_tiles.has(tile_index_facing)
#		var has_clearance = tile_index_facing == EMPTY_TILE_INDEX
		clearance_tile.set_has_clearance(has_clearance)
		return has_clearance


func _validate_eraser_position(cellv: Vector2) -> void:
	var tile_index = _ground.get_cellv(cellv)
	_valid_eraser = tile_index == STALL_TILE_INDEX
	_blueprint.set_valid(_valid_eraser)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("set_facing_left"):
		_blueprint.set_facing(Enums.ORIENTATION.LEFT)
	if event.is_action_pressed("set_facing_right"):
		_blueprint.set_facing(Enums.ORIENTATION.RIGHT)
	if event.is_action_pressed("set_facing_up"):
		_blueprint.set_facing(Enums.ORIENTATION.UP)
	if event.is_action_pressed("set_facing_down"):
		_blueprint.set_facing(Enums.ORIENTATION.DOWN)
	if event is InputEventMouseButton and event.is_action_pressed("ui_select"):
		if _placeable_blueprint:
			_place_entity()
		elif _valid_eraser:
			_remove_entity()


func _place_entity() -> void:
	var new_entity = _blueprint.entity_scene.instance() as Entity
	new_entity.position = _blueprint.position
	new_entity.orientation = _blueprint.facing_rotation
	var cellv = _ground.world_to_map(new_entity.position)
	_mark_ground(cellv, STALL_TILE_INDEX, _blueprint.facing_rotation)
	
	_tracker.place_entity(new_entity, cellv)
	add_child(new_entity)

	if new_entity is Stall:
		var front_cellv = _ground.world_to_map(new_entity.queue_position)		
		_mark_ground(front_cellv, STALL_FRONT_TILE_INDEX, _blueprint.facing_rotation)


func _remove_entity() -> void:
	var cellv = _ground.world_to_map(get_global_mouse_position())
	_tracker.remove_entity(cellv)
	_mark_ground(cellv, EMPTY_TILE_INDEX)


func save() -> Dictionary:
	var entities = {
		"stalls" : {},
		"tables" : {}
	}
	if _tracker.entities is Dictionary:
		for key in _tracker.entities:
			var entity = _tracker.entities[key]
			if entity is Stall:
				entities["stalls"][var2str(key)] = entity.serialize()
	return {
		"entities" : entities
	}


func _load() -> void:
	if not SaveFile.game_data.has("entities"):
		_register_children()
		return
	_delete_all_children()
	var entities = SaveFile.game_data["entities"]
	for type in entities:
		if type == "stalls":
			for cellv_string in entities[type]:
				var cellv = str2var(cellv_string)
				_load_stall(cellv, entities[type][cellv_string])


func _delete_all_children() -> void:
	for child in get_children():
		child.queue_free()


func _load_stall(cellv : Vector2, stall_data : Dictionary) -> void:
	var stall_scene = Resources.ENTITIES["stalls"]
	var stall = stall_scene.instance() as Stall
	var stall_position = _ground.map_to_world(cellv)
	stall.position = stall_position + tile_offset
	_mark_ground(cellv, STALL_TILE_INDEX, stall_data["or"])
	_tracker.place_entity(stall, cellv)
	add_child(stall)	
	stall.deserialize(stall_data)
	
	if stall is Stall:
		var front_cellv = _ground.world_to_map(stall.queue_position)		
		_mark_ground(front_cellv, STALL_FRONT_TILE_INDEX, stall_data["or"])
	
