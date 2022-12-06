extends MarginContainer

onready var collapsable_inventory := $HBoxContainer/HBoxContainer_Collapsable


func _ready() -> void:
	collapsable_inventory.visible = false


func _on_CheckBox_EnableCheckForClearance_toggled(button_pressed: bool) -> void:
	Events.emit_signal("check_clearance_changed", button_pressed)


func _on_Button_pressed() -> void:
	var visible = collapsable_inventory.visible
	if visible:
		Events.emit_signal("blueprint_selected", null)
	collapsable_inventory.visible = not visible
	$HBoxContainer/Control/ToggleButton_ExpansionMode.pressed = false


func _on_Button_ExpansionMode_toggled(button_pressed: bool) -> void:
	Events.emit_signal("expansion_mode_changed", button_pressed)
