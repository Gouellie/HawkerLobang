extends Entity
class_name Stall

export(Resource) var resource setget _set_resource

var stall_name : String setget _set_stall_name
var date_of_opening : DateTime
var dish_name : String

onready var business_hours : BusinessHours = $BusinessHours
onready var stall_shape : Polygon2D = $StallShape
onready var stall_name_label : Label = $Control/VBoxContainer/Label_StallName
onready var stall_type_label : Label = $Control/VBoxContainer/Label_StallType
onready var state_machine : StateMachine = $States

var is_stall_vacant : bool = true

func _ready() -> void:
	dish_name = resource.dish_name if resource else "$"
	stall_name_label.text = stall_name
	stall_type_label.text = dish_name


func create_stall(p_stall_name : String, p_resource : Resource, date : DateTime) -> void:
	stall_name = p_stall_name
	resource = p_resource
	date_of_opening = date
	dish_name = resource.dish_name if resource else "$"
	stall_name_label.text = stall_name
	stall_type_label.text = dish_name
	state_machine.transition_to("Open")
	is_stall_vacant = false
	# update the Toolbox
	Events.emit_signal("entity_selected", self)	


func close_stall() -> void:
	_set_stall_name("")
	_set_resource(null)
	state_machine.transition_to("Vacant")
	is_stall_vacant = true
	# update the Toolbox
	Events.emit_signal("entity_selected", self)	


func _on_Area2D_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if Global.builder_mode_on:
		return
	if event is InputEventMouse	and event.is_action_pressed("left_click"):
		Events.emit_signal("entity_selected", self)	


func _on_Area2D_mouse_entered(entered: bool) -> void:
	$StallShape_Outline.visible = entered


func _set_stall_is_open(open : bool) -> void:
	if open :
		stall_shape.color = Color.olivedrab
	else :
		stall_shape.color = Color.sandybrown


func _set_resource(p_resource : Resource) -> void:
	resource = p_resource
	dish_name = resource.dish_name if resource else "$"
	if stall_type_label:
		stall_type_label.text = dish_name


func _set_stall_name(p_name : String) -> void:
	stall_name = p_name
	if stall_name_label:
		stall_name_label.text = stall_name


func serialize() -> Dictionary:
	return {
		"or" : orientation,
		"sn" : stall_name,
		"do" : date_of_opening.ticks,
		"rs" : resource.resource_name if resource else "",
		"bh" : business_hours.serialize(),
	}
	
	
func deserialize(data : Dictionary) -> void:
	var stall_key = data["rs"]
	orientation = data["or"]
	if Resources.STALLS.has(stall_key) :
		create_stall(
				data["sn"], 
				Resources.STALLS[stall_key], 
				Dates.get_date_from_ticks(data["do"]))
		business_hours.deserialize(data["bh"])
