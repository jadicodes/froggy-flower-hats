extends Area2D

signal entered(frog, marker_position)

const FULL_TEXTURE = preload("res://stump/full.png")
const EMPTY_TEXTURE = preload("res://stump/empty.png")

enum StumpState {
	FULL,
	EMPTY
	}

var stump_state:
	set(state):
		if state == StumpState.EMPTY:
			set_texture()
		if state == StumpState.FULL:
			set_texture()
		stump_state = state

var _pampered_frog : Frog


func _ready() -> void:
	stump_state = StumpState.EMPTY
	set_texture()


func set_texture() -> void:
	match stump_state:
		StumpState.FULL:
			return
		StumpState.EMPTY:
			return


func _on_body_entered(body) -> void:
	if stump_state == StumpState.EMPTY and body is Frog:
		stump_state = StumpState.FULL

		emit_signal("entered", body, _get_marker_position())

		_pampered_frog = body
		print("Entered:" + str(_pampered_frog))
		print(stump_state)


func _on_body_exited(body) -> void:
	if body == _pampered_frog:
		stump_state = StumpState.EMPTY
		print("Exited:" + str(_pampered_frog))
		print(stump_state)


func _get_marker_position() -> Vector2:
	return $Marker.global_position
