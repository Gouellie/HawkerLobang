extends Popup
class_name OmniDialog

enum SELECTION {OK, YES, NO, CANCEL}

enum MODE {OK, YES_NO, YES_NO_CANCEL, OK_CANCEL}
export (MODE) var mode = MODE.OK
export (String) var title := ""
export (String) var message := ""

onready var label_title := $CenterContainer/Panel/MarginContainer/VBoxContainer/Label_Title
onready var label_message := $CenterContainer/Panel/MarginContainer/VBoxContainer/MarginContainer/Label_Message
onready var button_ok := $CenterContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/Button_Ok
onready var button_yes := $CenterContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/Button_Yes
onready var button_no := $CenterContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/Button_No
onready var button_cancel := $CenterContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/Button_Cancel

signal user_choice(selection)

func _ready() -> void:
	label_title.text = title
	label_message.text = message
	_setup_mode()
	Global.omni_dialog = self


func setup(_mode = MODE.OK, _title = "", _message = "") -> void:
	mode = _mode
	title = _title
	message = _message
	label_title.text = title
	label_message.text = message	
	_setup_mode()


func _setup_mode() -> void:
	button_ok.visible = false	
	button_yes.visible = false
	button_no.visible = false
	button_cancel.visible = false	
	match mode:
		MODE.OK:
			button_ok.visible = true
		MODE.OK_CANCEL:
			button_ok.visible = true
			button_cancel.visible = true
		MODE.YES_NO:
			button_yes.visible = true
			button_no.visible = true
		MODE.YES_NO_CANCEL:
			button_yes.visible = true
			button_no.visible = true
			button_cancel.visible = true


func _on_Button_Ok_pressed() -> void:
	visible = false
	emit_signal("user_choice", SELECTION.OK)


func _on_Button_Yes_pressed() -> void:
	visible = false
	emit_signal("user_choice", SELECTION.YES)
	

func _on_Button_No_pressed() -> void:
	visible = false
	emit_signal("user_choice", SELECTION.NO)
	

func _on_Button_Cancel_pressed() -> void:
	visible = false
	emit_signal("user_choice", SELECTION.CANCEL)
