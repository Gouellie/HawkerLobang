extends MarginContainer


onready var collapsable_inventory := $HBoxContainer/HBoxContainer_Collapsable
onready var button_hide_show := $HBoxContainer/Control/Button_HideShow

func _ready() -> void:
	button_hide_show.text = "Collapse"


func _on_CheckBox_EnableCheckForClearance_toggled(button_pressed: bool) -> void:
	Events.emit_signal("check_clearance_changed", button_pressed)



func _on_Button_pressed() -> void:
	var visible = collapsable_inventory.visible
	if visible:
		Events.emit_signal("blueprint_selected", null)
		button_hide_show.text = "Expand"
	else:
		button_hide_show.text = "Collapse"
	collapsable_inventory.visible = not visible
