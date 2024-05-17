extends Node2D
var _ready_to_pamper

var _frog: Frog


func _ready():
	_make_new_frog()


func _process(_delta):
	if _ready_to_pamper == true:
		if _frog._get_state() == 3:
			_frog.global_position = $Stump._get_marker_position()
			_frog._set_state(4)


func _on_stump_ready_to_pamper():
	_ready_to_pamper = true


func _on_stump_done_pampering():
	_ready_to_pamper = false


func _make_new_frog():
	#var _positions = [(-320, 660), (2180, 660)]
	_frog = preload("res://frog/frog.tscn").instantiate()
	call_deferred("add_child", _frog)
	_frog.global_position = Vector2(320, 660)


func _on_frog_spawn_timer_timeout():
	_make_new_frog()
