extends Area2D

signal entered(frog, marker_position)

const FULL_TEXTURE = preload("res://stump/full.png")
const EMPTY_TEXTURE = preload("res://stump/empty.png")

enum StumpState {
	FULL,
	EMPTY
	}

var stump_state = StumpState.EMPTY
var _pampered_frog : Frog

func _ready() -> void:
	set_texture()


func set_texture() -> void:
	match stump_state:
		StumpState.FULL:
			_set_sprite_texture(FULL_TEXTURE)
		StumpState.EMPTY:
			_set_sprite_texture(EMPTY_TEXTURE)


func _set_sprite_texture(tex) -> void:
	$Sprite.texture = tex


func _on_body_entered(body) -> void:
	if stump_state == StumpState.EMPTY and body is Frog:
		stump_state = StumpState.FULL

		emit_signal("entered", body, _get_marker_position())

		_pampered_frog = body
		set_texture()


func _on_body_exited(body) -> void:
	if body == _pampered_frog:
		stump_state = StumpState.EMPTY
		set_texture()


func _get_marker_position() -> Vector2:
	return $Marker.global_position
