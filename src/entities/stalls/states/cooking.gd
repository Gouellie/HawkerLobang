extends State

var time_to_cook : int = 15
var time_cooking : int
var patron : Patron

func enter(msg: Dictionary = {}) -> void:
	owner.label_state.text = "open/cooking"
	if msg.has("patron"):
		take_order(msg["patron"])
	

func exit() -> void:
	pass
	
	
func take_order(_patron : Patron) -> void:
	patron = _patron
	patron.taking_patron_order()
	time_to_cook = rand_range(5, 12) as int
	time_cooking = 0	
	

func on_time_ellapsed(date_time : DateTime) -> void:
	if not _parent.update_business_state(date_time, false) :
		return
	time_cooking += 1
	if time_cooking == time_to_cook:
		if is_instance_valid(patron):
			patron.serving_patron()
			_parent.set_to_idle()



