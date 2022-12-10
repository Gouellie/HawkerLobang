extends Node2D
class_name ExpansionTab

signal expanded(direction)

const RIGHT : int = 0
const DOWN : int = 1
const LEFT : int = 2
const UP : int = 3

export var direction : int
export var top_left : Vector2
export var size : Vector2
export var cell_size : float

onready var _rect : ColorRect = $ColorRect
onready var _polygon : CollisionPolygon2D = $Area2D/CollisionPolygon2D

const rect_color := Color(1.0,1.0,1.0,1.0)
const rect_color_no_highlight := Color(1.0,1.0,1.0,0.5)


func _ready() -> void:
	_rect.color = rect_color_no_highlight
	_update_rect()
	_update_polygon()


func _update_rect() -> void:
	_rect.rect_position = top_left	
	_rect.rect_size = size	


func _update_polygon() -> void:
	var width = (size).x
	var height = (size).y
	match direction:
		RIGHT:
			_polygon.polygon[0] = top_left + Vector2(0, cell_size)
			_polygon.polygon[1] = top_left + Vector2(0, height - cell_size)
			_polygon.polygon[2] = top_left + Vector2(width, height)
			_polygon.polygon[3] = top_left + Vector2(width, 0)
		DOWN:
			_polygon.polygon[0] = top_left + Vector2(cell_size, 0)
			_polygon.polygon[1] = top_left + Vector2(0, height)
			_polygon.polygon[2] = top_left + Vector2(width, height)
			_polygon.polygon[3] = top_left + Vector2(width - cell_size, 0) 
		LEFT:
			_polygon.polygon[0] = top_left
			_polygon.polygon[1] = top_left + Vector2(0, height)
			_polygon.polygon[2] = top_left + Vector2(width, height - cell_size)
			_polygon.polygon[3] = top_left + Vector2(width, cell_size) 
		UP:
			_polygon.polygon[0] = top_left
			_polygon.polygon[1] = top_left + Vector2(cell_size, height)
			_polygon.polygon[2] = top_left + Vector2(width - cell_size, height)
			_polygon.polygon[3] = top_left + Vector2(width, 0) 


func expand() -> void:
	match direction:
		RIGHT:
			top_left.x += cell_size
		DOWN:
			top_left.y += cell_size
		LEFT:
			top_left.x -= cell_size
		UP:
			top_left.y -= cell_size
	_update_rect()
	_update_polygon()


func neighbord_expanded(expand_dir : int) -> void:
	match direction:
		RIGHT:
			match expand_dir:
				UP:
					top_left.y -= cell_size
					size.y += cell_size	
				DOWN: 
					size.y += cell_size
		DOWN:
			match expand_dir:
				RIGHT:
					size.x += cell_size
				LEFT: 
					top_left.x -= cell_size
					size.x += cell_size	
		LEFT:
			match expand_dir:
				UP:
					top_left.y -= cell_size
					size.y += cell_size	
				DOWN: 
					size.y += cell_size
		UP:
			match expand_dir:
				RIGHT:
					size.x += cell_size
				LEFT: 
					top_left.x -= cell_size
					size.x += cell_size	
	_update_rect()
	_update_polygon()


func _on_Area2D_mouse_entered() -> void:
	_rect.color = rect_color


func _on_Area2D_mouse_exited() -> void:
	_rect.color = rect_color_no_highlight


func _on_Area2D_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not event is InputEventMouseButton:
		return
	if event.is_action_pressed("left_click"):
		expand()		
		emit_signal("expanded", direction)


func _on_ColorRect_gui_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	if event.is_action_pressed("left_click"):
		expand()		
		emit_signal("expanded", direction)
