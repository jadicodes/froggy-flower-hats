extends Node2D

const _MAX_FROGS = 4

@onready var _animation_player = $AnimationPlayer

var _frog: Frog
var _current_frogs: int = 0
var _spawn_locations: Array = [Vector2(-97, 810), Vector2(2018, 809)]

func _ready() -> void:
	_animation_player.play("fade_from_black")
	_make_new_frog()


func _make_new_frog() -> void:
	_frog = preload("res://frog/frog.tscn").instantiate()
	call_deferred("add_child", _frog)
	_frog.global_position = _spawn_locations.pick_random()
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
