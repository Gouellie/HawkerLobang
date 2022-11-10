extends TileMap
class_name EntityManager

export (NodePath) var ground_path
var _ground: TileMap

var tile_offset : Vector2

const NAMEOF_SELF := "entity_manager.gd"

const EMPTY_TILE_INDEX : int = 0
const STALL_TILE_INDEX : int = 1

var _blueprint : Blueprint
var _placeable_blueprint : bool

func _ready() -> void:
	_ground = get_node(ground_path) as TileMap
	tile_offset = _ground.cell_size / 2
	Log.log_error(Events.connect("blueprint_selected", self, "_on_blueprint_selected"), NAMEOF_SELF)
	_register_children()


func _process(_delta: float) -> void:
	if _blueprint:
		_move_blueprint(get_global_mouse_position())


func _register_children() -> void:
	for child in get_children():
		if child is Node2D:
			_mark_ground(child.position)


func _on_blueprint_selected(sender : Object) -> void:
	if sender == null:
		if _blueprint:
			_blueprint.queue_free()
			_blueprint = null
	elif sender is BlueprintPanel:
		if sender.blueprint_scene:
			_blueprint = sender.blueprint_scene.instance() as Blueprint
			add_child(_blueprint)
	_ground.visible = _blueprint != null


func _mark_ground(p_position: Vector2) -> void:
	var cellv = _ground.world_to_map(p_position)
	_ground.set_cellv(cellv, STALL_TILE_INDEX)	


func _move_blueprint(mouse_position: Vector2) -> void:
	var cellv = _ground.world_to_map(mouse_position)
	var tile_index = _ground.get_cellv(cellv)
	_placeable_blueprint = tile_index == EMPTY_TILE_INDEX
	var snap_position = _ground.map_to_world(cellv)
	_blueprint.position = snap_position + tile_offset


func _unhandled_input(event: InputEvent) -> void:
	if not _placeable_blueprint:
		return
	if event is InputEventMouseButton and event.is_action_pressed("ui_select"):
		_place_entity()


func _place_entity()-> void:
	var new_entity = _blueprint.entity_scene.instance() as Node2D
	new_entity.position = _blueprint.position
	_mark_ground(new_entity.position)
	add_child(new_entity)

