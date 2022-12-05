extends Entity
class_name TrayStation

onready var station_range : Area2D = $Area2D
var current_pos := 0
onready var max_pos : int
onready var _positions := []

func _ready() -> void:
	for pos in $Positions.get_children():
		_positions.append(pos.global_position) 
	max_pos = _positions.size()


func serialize() -> Dictionary:
	return .serialize()


func deserialize(data : Dictionary) -> void:
	.deserialize(data)


func post_deserialized() -> void:
	pass


func register() -> void:
	Global.tray_station_manager.register_station(self)


func cleanup() -> void:
	Global.tray_station_manager.remove_station(self)


func get_next_position() -> Vector2:
	current_pos = wrapi(current_pos+1, 0, max_pos)
	return _positions[current_pos]
