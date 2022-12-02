extends MarginContainer

var hawker_center : HawkerCenter

onready var status_label : Label = $VBoxContainer/MarginContainer/Label

func _ready() -> void:
	Log.log_error(Events.connect("hawker_center_changed", self, "_on_hawker_center_changed"))	


func _on_Button_HawkerSelect_pressed() -> void:
	Events.emit_signal("entity_selected", hawker_center)


func _on_hawker_center_changed(open : bool) -> void:
	var text = "(%s for Business)"
	status_label.text = text % "Open" if open else text % "Close"
