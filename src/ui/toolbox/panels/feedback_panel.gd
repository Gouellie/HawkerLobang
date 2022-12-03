extends ToolboxPanel


const feedback_preload = preload("res://src/ui/controls/feedback_control.tscn")

onready var feedbacks := $MarginContainer/VBoxContainer/ScrollContainer/Feedbacks

var hawker_center : HawkerCenter


func load_entity(entity : Entity) -> bool:
	selected_entity = entity
	if entity is HawkerCenter:
		hawker_center = selected_entity
		Log.log_error(Events.connect("send_feedback", self, "on_feedback_sent"))		
		_load_feedbacks()
		return true
	return false
	
	
func unload_entity() -> void:
	Events.disconnect("send_feedback", self, "on_feedback_sent")
	_delete_feedbacks()


func _delete_feedbacks() -> void:
	for feedback in feedbacks.get_children():
		feedback.queue_free()


func _load_feedbacks() -> void:
	for feedback in hawker_center.feedbacks:
		_load_feedback(feedback)


func _load_feedback(feedback : Feedback) -> void:
		var feedback_control = feedback_preload.instance()
		feedback_control.connect("entry_deleted", self, "on_entry_deleted")
		feedback_control.feedback = feedback
		feedbacks.add_child(feedback_control)	


func on_entry_deleted(entry) -> void:
	hawker_center.delete_feeback_entry(entry.feedback)
	feedbacks.remove_child(entry)
	

func on_feedback_sent(feedback : Feedback) -> void:
	_load_feedback(feedback)


func _on_Button_Clear_pressed() -> void:
	hawker_center.delete_feedbacks()	
	_delete_feedbacks()
