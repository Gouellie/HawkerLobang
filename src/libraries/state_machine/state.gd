# State interface to use in Hierarchical State machines
# The lowest leaf tries to handle callbacks and if it can'it, it delegates the work to its parent.
class_name State, "res://assets/icons/state.svg"
extends Node2D

onready var _state_machine := _get_state_machine(self)

var _parent: State = null


func _ready() -> void:
	yield(owner, "ready")
	_parent = get_parent() as State


func on_time_ellapsed(_dateTime : DateTime) -> void:
	pass
	
func on_speed_changed(_speed : int) -> void:
	pass


func unhandled_input(_event: InputEvent) -> void:
	pass


func physics_process(_delta: float) -> void:
	pass


func enter(_msg: Dictionary = {}) -> void:
	pass


func exit() -> void:
	pass


func _get_state_machine(node: Node) -> Node:
	if node != null and not node.is_in_group("state_machine"):
		return _get_state_machine(node.get_parent())
	return node
