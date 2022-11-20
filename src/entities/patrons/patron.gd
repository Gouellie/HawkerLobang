extends Entity
class_name Patron

var selected : bool setget set_selected,get_selected
onready var skin : Sprite = $Patron


func _ready() -> void:
	Log.log_error(Events.connect("entity_selected", self, "_on_entity_selected"))
	

func _draw() -> void:
	if selected:
		draw_arc(Vector2.ZERO, 15, 0, TAU, 32, Color.aqua, 1.0)


func _on_Area2D_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if Global.builder_mode_on:
		return
	if event is InputEventMouse	:
		if event.is_action_pressed("left_click"):
			Events.emit_signal("entity_selected", self)	


func _on_entity_selected(entity : Entity) -> void:
	set_selected(entity == self)


func set_selected(p_selected : bool) -> void:
	selected = p_selected
	update()


func get_selected() -> bool:
	return selected
