extends Entity

class_name Table

onready var table_range : Area2D = $Area2D
onready var label_state : Label = $Label_Shope
onready var trays := []

onready var positions : PoolVector2Array
var seats_count : int

func _ready() -> void:
	Log.log_error(Events.connect("toggle_label_display", self, "_toggle_label_display"))	
	label_state.text = ""	
	label_state.visible = Global.show_states		
	for pos in $Positions.get_children():
		positions.push_back(pos.global_position)
	for tray in $Trays.get_children():
		trays.push_back(tray)
	seats_count = positions.size()


func serialize() -> Dictionary:
	return .serialize()


func deserialize(data : Dictionary) -> void:
	.deserialize(data)
	positions = []


func table_reserved(is_reserved : bool) -> void:
	label_state.text = "chope" if is_reserved else ""


func get_sitting_position(pos : int) -> Vector2:
	assert(seats_count > pos, "Not enough seats %d for request %d" % [seats_count, pos])
	return positions[pos]


func patron_sit_at_position(pos : int) -> void:
	trays[pos].visible = true


func patron_leave_position(pos : int, with_tray : bool) -> void:
	if with_tray:
		trays[pos].visible = false


func _toggle_label_display(show : bool) -> void:
	label_state.visible = show


func register() -> void:
	Global.table_manager.register_table(self)


func cleanup() -> void:
	Global.table_manager.remove_table(self)
