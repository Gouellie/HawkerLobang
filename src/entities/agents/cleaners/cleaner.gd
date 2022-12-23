extends Entity
class_name Cleaner

var is_in_shift : bool
var shift_start : TimeOnly = TimeOnly.new(6,0)
var shift_end : TimeOnly = TimeOnly.new(22,00)

onready var skin : Node2D = $Skin
onready var state_machine : StateMachine = $States
onready var label_state : Label = $Label_State 


func _ready() -> void:
	Log.log_error(Events.connect("time_ellapsed", self, "on_time_ellapsed"))


func on_time_ellapsed(date : DateTime) -> void:
	var was_in_shift = is_in_shift
	is_in_shift = Dates.in_time_only(date, shift_start, shift_end)
	if not was_in_shift and is_in_shift:
		_start_shift()
	elif was_in_shift and not is_in_shift:
		_end_shift() 


func _start_shift() -> void:
	if state_machine.state.has_method("start_shift"):
		state_machine.state.start_shift()


func _end_shift() -> void:
	if state_machine.state.has_method("end_shift"):
		state_machine.state.end_shift()


func _on_Area2D_area_shape_entered(_area_rid: RID, _area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	pass


func can_track_entity() -> bool:
	return true


func on_entity_selected(entity) -> void:
	if entity == self:
		print(entity)


func _on_Area2D_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if Global.builder_mode_on:
		return
	if event is InputEventMouse	:
		if event.is_action_pressed("left_click"):
			Events.emit_signal("entity_selected", self)	
