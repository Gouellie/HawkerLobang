extends Entity
class_name Patron

var is_in_patron_group : bool
var is_group_leader : bool
var sit_index : int = 0
var group_size : int
var group_id
var ready_to_leave : bool

var selected : bool setget set_selected,get_selected

onready var skin : Sprite = $Patron
onready var state_machine : StateMachine = $States
onready var label_state : Label = $Label_State 
onready var stall_detector : Area2D = $Stall_Dectection


func _ready() -> void:
	Log.log_error(Events.connect("toggle_label_display", self, "_toggle_label_display"))	
	Log.log_error(Events.connect("entity_selected", self, "_on_entity_selected"), "patron.gd")
	label_state.visible = Global.show_states
	

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


func break_queue() -> void:
	if state_machine.state.has_method("break_queue"):
		state_machine.state.break_queue()


func is_patron_in_queue() -> bool:
	if state_machine.state.has_method("is_patron_in_queue"):
		return state_machine.state.is_patron_in_queue()
	return false


func taking_patron_order() -> void:
	if state_machine.state.has_method("taking_patron_order"):
		state_machine.state.taking_patron_order()


func serving_patron() -> void:
	if state_machine.state.has_method("serving_patron"):
		state_machine.state.serving_patron()
	
	
func leave() -> void:
	if state_machine.state.has_method("leave"):
		state_machine.state.leave()


func update_position_in_queue(pos : Vector2) -> void:
	if state_machine.state.has_method("update_position_in_queue"):
		state_machine.state.update_position_in_queue(pos)


func _on_Area2D_area_shape_entered(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	if state_machine.state.has_method("on_Area2D_body_entered"):
		state_machine.state.on_Area2D_body_entered(area.owner)


func _toggle_label_display(show : bool) -> void:
	label_state.visible = show


func cleanup() -> void:
	state_machine.state.cleanup()
