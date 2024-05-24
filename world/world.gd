extends Node2D

var _frog: Frog


func _ready() -> void:
	_make_new_frog()


func _make_new_frog() -> void:
	_frog = preload("res://frog/frog.tscn").instantiate()
	call_deferred("add_child", _frog)
	_frog.global_position = Vector2(320, 660)


func _on_frog_spawn_timer_timeout() -> void:
	_make_new_frog()


func _on_stump_entered(frog, marker_position) -> void:
	frog._set_state(4)
	frog._set_position(marker_position)
