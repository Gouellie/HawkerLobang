extends MarginContainer

var hawker_center : HawkerCenter

onready var status_label : Label = $HBoxContainer/VBoxContainer/MarginContainer/Label
onready var open_hawker_button := $HBoxContainer/Control/Button_OpenHawker

func _ready() -> void:
	Log.log_error(Events.connect("hawker_center_changed", self, "on_hawker_center_changed"))
	Log.log_error(Events.connect("pause_simulation", self, "on_simulation_paused"))


func _on_Button_HawkerSelect_pressed() -> void:
	Events.emit_signal("entity_selected", hawker_center)


func on_hawker_center_changed(open : bool) -> void:
	var text = "(%s for Business)"
	status_label.text = text % "Open" if open else text % "Close"
	

func on_simulation_paused(paused : bool) -> void:
	open_hawker_button.visible = paused


func _on_Button_OpenHawker_pressed() -> void:
	open_hawker_button.visible = false
	# todo, replace by signal?
	hawker_center.start_new_day()
