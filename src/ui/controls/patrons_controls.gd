extends MarginContainer

onready var label_patrons := $HBoxContainer/Control/Label_Patrons
onready var spawn_patrons_count : SpinBox = $HBoxContainer/SpinBox_PatronCount


func _ready() -> void:
	Log.log_error(Events.connect("patron_count_changed", self, "_on_patron_count_changed"))
	_on_patron_count_changed(Global.get_patrons_count())


func _on_patron_count_changed(count : int) -> void:
	label_patrons.text = "Patrons : %d" % count 


func _on_Button_ClearPatrons_pressed() -> void:
	Events.emit_signal("clear_patrons_requested")


func _on_Button_SpawnPatron_pressed() -> void:
	# warning-ignore:narrowing_conversion
	var invoke_count : int = spawn_patrons_count.value
	Events.emit_signal("patron_invoked", invoke_count, true)


func _on_CheckBox_show_states_toggled(show: bool) -> void:
	Events.emit_signal("toggle_label_display", show)
	Global.show_states = show

