extends Entity

class_name Table

var dirty_notified : bool
var dirtiness : float
var pax_count : int

onready var table_range : Area2D = $Area2D
onready var label_state : Label = $Label_Shope
onready var dirtiness_bar : ProgressBar = $ProgressBar_Dirtiness
onready var trays := []
onready var positions : PoolVector2Array
onready var seats_count : int
onready var positions_occupancy : Array

onready var position_cleaner : Vector2 = $Position_Cleaner.global_position 


func _ready() -> void:
	Log.log_error(Events.connect("toggle_label_display", self, "_toggle_label_display"))
	Log.log_error(Events.connect("time_ellapsed", self, "on_time_ellapsed"))
	label_state.text = ""	
	label_state.visible = Global.show_states
#	dirtiness_bar.visible = Global.show_states
	for pos in $Positions.get_children():
		positions.push_back(pos.global_position)
	for tray in $Trays.get_children():
		trays.push_back(tray)
	seats_count = positions.size()
	for seat in seats_count:
		positions_occupancy.append(false)


func serialize() -> Dictionary:
	return .serialize()


func deserialize(data : Dictionary) -> void:
	.deserialize(data)
	positions = []

func on_time_ellapsed(_date) -> void:
	if pax_count == 0:
		return
	dirtiness = min(100, dirtiness + 0.2 * pax_count)
	if not dirty_notified and dirtiness > 40:
		Global.table_manager.notify_dirty_table(self, true)
		dirty_notified = true
	if dirtiness_bar:
		dirtiness_bar.value = dirtiness


func table_reserved(is_reserved : bool) -> void:
	label_state.text = "chope" if is_reserved else ""


func get_sitting_position(pos : int) -> Vector2:
	assert(seats_count > pos, "Not enough seats %d for request %d" % [seats_count, pos])
	return positions[pos]


func patron_sit_at_position(pos : int) -> void:
	trays[pos].visible = true
	pax_count += 1
	positions_occupancy[pos] = true


func patron_leave_position(pos : int, with_tray : bool) -> void:
	if with_tray:
		trays[pos].visible = false
	pax_count -= 1
	positions_occupancy[pos] = false	


func _toggle_label_display(show : bool) -> void:
	label_state.visible = show
#	dirtiness_bar.visible = show


func register() -> void:
	Global.table_manager.register_table(self)


func cleaner_clean_table() -> float:
	var current_dirtiness = dirtiness
	table_cleaned()
	Global.table_manager.notify_dirty_table(self, false)	
	return current_dirtiness


func table_cleaned() -> void:
	dirtiness = 0.0
	dirty_notified = false	
	if dirtiness_bar:
		dirtiness_bar.value = dirtiness
	var pos_numb := 0
	for position_occupied in positions_occupancy:
		if not position_occupied:
			trays[pos_numb].visible = false
		pos_numb += 1 


func clean_table() -> void:
	pax_count = 0
	for i in range(positions_occupancy.size()):
		positions_occupancy[i] = false
	table_cleaned()


func cleanup() -> void:
	Global.table_manager.remove_table(self)
