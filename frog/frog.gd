extends CharacterBody2D
class_name Frog

signal _left

const SPEED : float = 100.0

const WALK = preload("res://frog/idle.png")
const IDLE = preload("res://frog/idle.png")
const GRABBED = preload("res://frog/grabbed.png")
const BEING_PAMPERED = preload("res://frog/being_pampered.png")
const FALLING = preload("res://frog/falling.png")

const DAISY = preload("res://frog/daisy_hat.png")

enum frog_state {
	WALK,
	IDLE,
	GRABBED,
	FALLING,
	BEING_PAMPERED,
	DONE,
}

var _possible_times: Array = [1, 2, 3, 5, 8]
var _gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var _direction : int
var _has_hat : bool = false

var _frog_state:
	set(state):
		if state == frog_state.WALK:
			_set_sprite_texture(WALK)
			set_collision_layer_value(4, false)
			_change_hat_position(Vector2(-2, -63))
			_reset_z_index()
			if $RayCastLeft.is_colliding():
				_direction = 1
			if $RayCastRight.is_colliding():
				_direction = -1

		if state == frog_state.IDLE:
			_set_sprite_texture(IDLE)
			set_collision_layer_value(4, false)
			_reset_z_index()
			_change_hat_position(Vector2(-2, -63))
			_set_timer()

		if state == frog_state.GRABBED:
			_set_sprite_texture(GRABBED)
			set_collision_layer_value(4, false)
			z_index = 10
			_change_hat_position(Vector2(-2, -88))

		if state == frog_state.FALLING:
			$FallingTimer.start()
			set_collision_layer_value(4, true)
			_change_hat_position(Vector2(-2, -88))

		if state == frog_state.BEING_PAMPERED:
			_set_sprite_texture(BEING_PAMPERED)
			set_collision_layer_value(4, true)
			_reset_z_index()
			_change_hat_position(Vector2(-2, -63))

		_frog_state = state


func _ready() -> void:
	_frog_state = frog_state.WALK
	_set_timer()


func _physics_process(delta) -> void:
	if _frog_state == frog_state.GRABBED:
		velocity.y = 0
		position = get_global_mouse_position()

	if _frog_state == frog_state.FALLING:
		velocity.y += _gravity * delta
		velocity.x = 0
		
		if is_on_floor():
			_frog_state = frog_state.IDLE

	if _frog_state == frog_state.WALK:
		if _has_hat == true:
			velocity.x = _direction * SPEED
			$DecisionTimer.stop()
			set_collision_mask_value(2, false)
			$GrabDetector.input_pickable = false
		else:
			velocity.y += _gravity * delta
			velocity.x = _direction * SPEED

	if _frog_state == frog_state.IDLE:
		velocity.y += _gravity * delta
		velocity.x = 0

	if _frog_state == frog_state.BEING_PAMPERED:
		velocity.y = 0
		velocity.x = 0

	move_and_slide()


func _reset_z_index() -> void:
	z_index = 3


func _set_state(state: int) -> void:
	_frog_state = state


func _set_timer() -> void:
	$DecisionTimer.wait_time = _possible_times.pick_random()


func _set_sprite_texture(texture: CompressedTexture2D) -> void:
	$Sprite.texture = texture


func _set_position(marker_position) -> void:
	global_position = marker_position


func _on_decision_timer_timeout() -> void:
	if _frog_state == frog_state.WALK:
		_frog_state = frog_state.IDLE
		return

	if _frog_state == frog_state.IDLE:
		_frog_state = frog_state.WALK
		return


func _on_grab_detector_input_event(_viewport, event, _shape_idx) -> void:
	if _frog_state != frog_state.GRABBED and event.is_action_pressed("grab"):
		_frog_state = frog_state.GRABBED
	if _frog_state == frog_state.GRABBED and event.is_action_released("grab"):
		_frog_state = frog_state.FALLING


func _get_state() -> int:
	return _frog_state


func _on_falling_timer_timeout() -> void:
	if _get_state() == 3:
		_set_sprite_texture(FALLING)


func _on_grab_detector_area_entered(area) -> void:
	if area is FlowerBud and _frog_state == 4 and _has_hat == false:
		area.queue_free()
		$Hat.texture = DAISY
		_has_hat = true


func _change_hat_position(pos : Vector2) -> void:
	$Hat.position = pos


func _on_visible_on_screen_notifier_screen_exited() -> void:
	_left.emit()
	queue_free()
