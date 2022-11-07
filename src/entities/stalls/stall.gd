extends Node2D

export(Resource) var resource setget _set_resource

var stall_name : String setget _set_stall_name
var dish_name : String

onready var stall_shape : Polygon2D = $StallShape
onready var stall_name_label : Label = $Control/VBoxContainer/Label_StallName
onready var stall_type_label : Label = $Control/VBoxContainer/Label_StallType
onready var state_machine : StateMachine = $States

func _ready() -> void:
	dish_name = resource.dish_name if resource else "$"
	stall_name_label.text = stall_name
	stall_type_label.text = dish_name


func on_tick(_datetime : DateTime) -> void:
	pass


func _on_Area2D_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouse	and event.is_action_pressed("select"):
		state_machine.select(event)


func _on_Area2D_mouse_entered(entered: bool) -> void:
	$StallShape_Outline.visible = entered


func _set_stall_is_open(open : bool) -> void:
	if open :
		stall_shape.color = Color.olivedrab
	else :
		stall_shape.color = Color.sandybrown


func _set_resource(p_resource : Resource) -> void:
	resource = p_resource
	dish_name = resource.dish_name	
	stall_type_label.text = dish_name


func _set_stall_name(p_name : String) -> void:
	stall_name = p_name
	stall_name_label.text = stall_name
