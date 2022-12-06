extends Node2D

const GROUND_TILE_INDEX : int = 0
const expansion_scene := preload("res://src/objects/expansion_tab.tscn")

export (NodePath) var ground_path

onready var _ground : TileMap
var expension_mode_active : bool

onready var tile_offset : Vector2

onready var tab_up : ExpansionTab
onready var tab_down : ExpansionTab
onready var tab_right : ExpansionTab
onready var tab_left : ExpansionTab

var top_left := Vector2(9000,9000)
var bottom_right := Vector2(0,0)
var expansions : PoolIntArray = []


func _ready() -> void:
	Log.log_error(Events.connect("expansion_mode_changed", self, "on_expansion_mode_changed"))	
	Log.log_error(Events.connect("blueprint_selected", self, "on_blueprint_selected"))	
	_ground = get_node(ground_path) as TileMap
	visible = true
	expension_mode_active = false
	tile_offset = _ground.cell_size / 2
	_get_dimensions()
	var real_top_left = _ground.map_to_world(top_left)
	var real_bottom_right = _ground.map_to_world(bottom_right)
	var width : float = real_bottom_right.x - real_top_left.x  + _ground.cell_size.x
	var height : float = real_bottom_right.y - real_top_left.y  + _ground.cell_size.y

	tab_up = expansion_scene.instance() as ExpansionTab
	tab_up.top_left = real_top_left
	tab_up.size = Vector2(width, _ground.cell_size.y)
	tab_up.cell_size = _ground.cell_size.x
	tab_up.direction = ExpansionTab.UP
	# warning-ignore:return_value_discarded
	tab_up.connect("expanded", self, "on_expanded")
	add_child(tab_up)
	
	tab_down = expansion_scene.instance() as ExpansionTab
	tab_down.top_left = Vector2(real_top_left.x, real_bottom_right.y)
	tab_down.size = Vector2(width, _ground.cell_size.y)
	tab_down.cell_size = _ground.cell_size.x
	tab_down.direction = ExpansionTab.DOWN
	# warning-ignore:return_value_discarded
	tab_down.connect("expanded", self, "on_expanded")	
	add_child(tab_down)
	
	tab_right = expansion_scene.instance() as ExpansionTab
	tab_right.top_left = Vector2(real_bottom_right.x, real_top_left.y)
	tab_right.size = Vector2(_ground.cell_size.x, height)
	tab_right.cell_size = _ground.cell_size.x
	tab_right.direction = ExpansionTab.RIGHT
	# warning-ignore:return_value_discarded
	tab_right.connect("expanded", self, "on_expanded")	
	add_child(tab_right)
	
	tab_left = expansion_scene.instance() as ExpansionTab
	tab_left.top_left = real_top_left
	tab_left.size = Vector2(_ground.cell_size.x, height)
	tab_left.cell_size = _ground.cell_size.x
	tab_left.direction = ExpansionTab.LEFT
	# warning-ignore:return_value_discarded
	tab_left.connect("expanded", self, "on_expanded")	
	add_child(tab_left)
	_load()
	set_tab_visibility()


func _get_dimensions() -> void:
	for cell in _ground.get_used_cells():
		if cell.x < top_left.x:
			top_left.x = cell.x
		if cell.y < top_left.y:
			top_left.y = cell.y
		if cell.x > bottom_right.x:
			bottom_right.x = cell.x
		if cell.y > bottom_right.y:
			bottom_right.y = cell.y
	top_left -= Vector2(1.0,1.0)
	bottom_right += Vector2(1.0,1.0)


func on_expanded(direction : int) -> void:
	expansions.append(direction)
	_expand_tabs(direction)
	_update_tiles()


func _expand_tabs(direction : int) -> void:
	match direction :
		ExpansionTab.RIGHT :
			bottom_right.x += 1
			tab_up.neighbord_expanded(direction)
			tab_down.neighbord_expanded(direction)
		ExpansionTab.DOWN :
			bottom_right.y += 1	
			tab_left.neighbord_expanded(direction)
			tab_right.neighbord_expanded(direction)
		ExpansionTab.LEFT :
			top_left.x -= 1
			tab_up.neighbord_expanded(direction)
			tab_down.neighbord_expanded(direction)
		ExpansionTab.UP :
			top_left.y -= 1	
			tab_left.neighbord_expanded(direction)
			tab_right.neighbord_expanded(direction)


func _update_tiles() -> void:
	var x_0 = top_left.x
	var x_1 = bottom_right.x 
	var y_0 = top_left.y
	var y_1 = bottom_right.y
	for col in range(x_0, x_1 + 1):
		for row in range(y_0, y_1 + 1):
			var cellv = Vector2(col, row)
			var is_border = col == x_0 or col == x_1 or row == y_0 or row == y_1
			if is_border:
				continue
			if _ground.get_cellv(cellv) >= 0:
				continue
			_ground.set_cellv(cellv, GROUND_TILE_INDEX)


func save() -> Dictionary:
	return { "expansions" : expansions }


func _load() -> void:
	if not SaveFile.game_data.has("expansions"):
		return
	expansions = SaveFile.game_data["expansions"]
	for ex in expansions:
		_expand_tab_load(ex)
	_update_tiles()


func _expand_tab_load(direction : int) -> void:
	match direction :
		ExpansionTab.RIGHT :
			tab_right.expand()
		ExpansionTab.DOWN :
			tab_down.expand()
		ExpansionTab.LEFT :
			tab_left.expand()
		ExpansionTab.UP :
			tab_up.expand()
	_expand_tabs(direction)			


func on_expansion_mode_changed(value : bool) -> void:
	expension_mode_active = value
	set_tab_visibility()


func on_blueprint_selected(_value) -> void:
	expension_mode_active = false
	set_tab_visibility()


func set_tab_visibility() -> void:
	tab_right.visible = expension_mode_active
	tab_down.visible = expension_mode_active
	tab_left.visible = expension_mode_active
	tab_up.visible = expension_mode_active
