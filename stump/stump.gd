extends Area2D

signal entered(frog, marker_position)

const FULL_TEXTURE = preload("res://stump/full.png")
const EMPTY_TEXTURE = preload("res://stump/empty.png")

var _is_empty : bool
var _pampered_frog : Frog


func _ready() -> void:
	_is_empty = true


func _on_body_entered(body) -> void:
	if _is_empty == true and body is Frog:
		_is_empty = false

		emit_signal("entered", body, _get_marker_position())

		_pampered_frog = body


func _on_body_exited(body) -> void:
	if body == _pampered_frog:
		_is_empty = true


func _get_marker_position() -> Vector2:
	return $Marker.global_position
