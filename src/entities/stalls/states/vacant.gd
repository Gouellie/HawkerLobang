extends State


func enter(_msg: Dictionary = {}) -> void:
	owner.label_state.text = "vacant"
	if owner.sprite_stall is Sprite:
		owner.sprite_stall.frame = 0
