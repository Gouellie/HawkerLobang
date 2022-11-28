extends Entity

class_name Table

onready var table_range : Area2D = $Area2D
onready var label_state : Label = $Label_Shope

var positions : PoolVector2Array

func _ready() -> void:
	Log.log_error(Events.connect("toggle_label_display", self, "_toggle_label_display"))	
	label_state.text = ""	
	label_state.visible = Global.show_states		
	for pos in $Positions.get_children():
		positions.push_back(pos.global_position)
	

func serialize() -> Dictionary:
	return .serialize()


func deserialize(data : Dictionary) -> void:
	.deserialize(data)
	Global.table_manager.register_table(self)


func table_reserved() -> void:
	label_state.text = "chope"


func get_sitting_position() -> PoolVector2Array:
	return positions


func patron_leave_table() -> void:
	label_state.text = ""
	Global.table_manager.register_table(self)
	

func _toggle_label_display(show : bool) -> void:
	label_state.visible = show


func register() -> void:
	Global.table_manager.register_table(self)


func cleanup() -> void:
	Global.table_manager.remove_table(self)
