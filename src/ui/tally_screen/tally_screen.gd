extends MarginContainer

onready var label_date :Label= $CenterContainer/Control/Panel/VBoxContainer_Top/Label_Date
onready var label_total_patrons :Label= $CenterContainer/Control/Panel/VBoxContainer/Label_TotalPatronsCount
onready var label_max_patrons :Label= $CenterContainer/Control/Panel/VBoxContainer/Label_MaxPatrons

func _ready() -> void:
	visible = false
	Log.log_error(Events.connect("tally_screen_requested", self, "on_tally_screen_requested"))


func _on_Button_Continue_pressed() -> void:
	visible = false
	Events.emit_signal("tally_screen_closed")


func on_tally_screen_requested(msg : Dictionary) -> void:
	visible = true
	var date = msg["date"] as DateTime
	var total_patrons_counts : int = msg["total_patrons"]
	var max_patron_counts : int = msg["max_patrons"]
	label_date.text = date.to_string_date_only()
	label_total_patrons.text = "Total Patrons : %d" % total_patrons_counts
	label_max_patrons.text = "Max Patrons : %d" % max_patron_counts
