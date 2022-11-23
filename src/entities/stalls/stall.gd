extends Entity
class_name Stall

export(Resource) var resource setget _set_resource

var stall_name : String setget _set_stall_name
var date_of_opening : DateTime
var dish_name : String

onready var business_hours : BusinessHours = $BusinessHours
onready var sprite_stall : Sprite = $Sprite_Stall
onready var stall_name_label : Label = $Control/VBoxContainer/Label_StallName
onready var stall_type_label : Label = $Control/VBoxContainer/Label_StallType
onready var state_machine : StateMachine = $States

var queue_position : Vector2 setget ,get_queue_position

var is_stall_vacant : bool = true

var cell_stamps : Array setget ,get_cell_stamps

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
	date_of_opening = null
	# update the Toolbox
	Events.emit_signal("entity_selected", self)	


func _on_Area2D_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if Global.builder_mode_on:
		return
	if event is InputEventMouse	:
		if event.is_action_pressed("left_click"):
			Events.emit_signal("entity_selected", self)	
		if event.is_action_pressed("right_click"):
			Events.emit_signal("entity_debug_selected", self)	


func _on_Area2D_mouse_entered(entered: bool) -> void:
	$Sprite_StallOutline.visible = entered


func set_stall_is_open(open : bool) -> void:
	if open :
		sprite_stall.frame = 1
	else :
		sprite_stall.frame = 2


func _set_resource(p_resource : Resource) -> void:
	resource = p_resource
	dish_name = resource.dish_name if resource else "$"
	if stall_type_label:
		stall_type_label.text = dish_name


func _set_stall_name(p_name : String) -> void:
	stall_name = p_name
	if stall_name_label:
		stall_name_label.text = stall_name


func get_queue_position() -> Vector2:
	return $Queue/QueuePosition.global_position


func serialize() -> Dictionary:
	var data = .serialize()
	data.merge({
		"sn" : stall_name,
		"do" : date_of_opening.ticks if date_of_opening else 0,
		"rs" : resource.resource_name if resource else "",
		"bh" : business_hours.serialize(),
		})
	return data
	
	
func deserialize(data : Dictionary) -> void:
	.deserialize(data)
	var stall_key = data["rs"]
	if Resources.STALLS.has(stall_key) :
		create_stall(
				data["sn"], 
				Resources.STALLS[stall_key], 
				Dates.get_date_from_ticks(data["do"]))
		business_hours.deserialize(data["bh"])


func get_cell_stamps() -> Array:
	return $cell_stamps.get_children()
