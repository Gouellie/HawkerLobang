extends Entity
class_name Stall

signal loaded

export(Resource) var resource setget _set_resource

var business_hours : BusinessHours = BusinessHours.new()

var stall_name : String setget _set_stall_name
var date_of_opening : DateTime
var dish_name : String

var _state_name : String


onready var queue_manager := $QueueManager 
onready var sprite_stall : Sprite = $Sprite_Stall
onready var state_machine : StateMachine = $States

# used by the states
onready var label_state : Label = $Label_State

# debug
var is_always_open : bool
var is_manually_closed : bool

var is_stall_vacant : bool = true
var is_open_for_business : bool
var queue_position : Vector2 setget ,get_queue_position
var counter_position : Vector2 setget ,get_counter_position

var cell_stamps : Array setget ,get_cell_stamps


func _ready() -> void:
	Log.log_error(Events.connect("toggle_label_display", self, "_toggle_label_display"))
	dish_name = resource.dish_name if resource else "$"
	label_state.visible = Global.show_states
	label_state.rect_rotation = -rotation_degrees


func initialize_stall(
		p_stall_name : String, 
		p_resource : Resource, 
		date : DateTime)-> void:
	stall_name = p_stall_name
	resource = p_resource
	date_of_opening = date
	dish_name = resource.dish_name if resource else "$"
	is_stall_vacant = false


func open_stall(
			p_stall_name : String, 
			p_resource : Resource, 
			date : DateTime) -> void:
	initialize_stall(p_stall_name, p_resource, date)
	state_machine.transition_to("Rented")
	# update the Toolbox
	Events.emit_signal("entity_selected", self)	
		

# debug method that sets the stall to always be open even when outside of B/H
# todo, method to resume operating within business hours
func set_is_open(open : bool) -> void:
	if is_stall_vacant:
		return
	if open :
		is_always_open = true
		is_manually_closed = false
		state_machine.transition_to("Rented/Open")
	else:
		is_always_open = false
		is_manually_closed = true
		state_machine.transition_to("Rented/Close")


func vacate_stall() -> void:
	_set_stall_name("")
	_set_resource(null)
	state_machine.transition_to("Vacant")
	queue_manager.set_stall_open(false)	
	is_stall_vacant = true
	date_of_opening = null
	is_always_open = false
	is_manually_closed = false	
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


func _set_resource(p_resource : Resource) -> void:
	resource = p_resource
	dish_name = resource.dish_name if resource else "$"


func _set_stall_name(p_name : String) -> void:
	stall_name = p_name


func get_queue_position() -> Vector2:
	return $QueueManager/QueuePosition.global_position
	
	
func  get_counter_position() -> Vector2:
	return $CounterPosition.global_position


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
		initialize_stall(
				data["sn"], 
				Resources.STALLS[stall_key], 
				Dates.get_date_from_ticks(data["do"]))
		business_hours.deserialize(data["bh"])
		_state_name = "Rented"
	emit_signal("loaded")


func post_deserialized() -> void:
	if _state_name :
		state_machine.transition_to(_state_name)	


func register() -> void:
	emit_signal("loaded")	
	Global.stall_manager.register_stall(self)


func get_cell_stamps() -> Array:
	return $cell_stamps.get_children()


func _toggle_label_display(show : bool) -> void:
	label_state.visible = show


func cleanup() -> void:
	Global.stall_manager.remove_stall(self)
