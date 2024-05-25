extends Node2D

const _MAX_FROGS = 4

var _frog: Frog
var _current_frogs: int = 0

func _ready() -> void:
	_make_new_frog()


func _make_new_frog() -> void:
	_frog = preload("res://frog/frog.tscn").instantiate()
	call_deferred("add_child", _frog)
	_frog.global_position = Vector2(320, 660)
	_frog._left.connect(_subtract_frog)


func _on_frog_spawn_timer_timeout() -> void:
	if _current_frogs < _MAX_FROGS:
		_current_frogs += 1
		_make_new_frog()


func _on_stump_entered(frog, marker_position) -> void:
	frog._set_state(4)
	frog._set_position(marker_position)

func _subtract_frog() -> void:
	_current_frogs -= 1
