extends Control


func _ready() -> void:
	Jukebox._play_music()
	$AnimationPlayer.play("title")


func _on_play_button_pressed() -> void:
	$AnimationPlayer.play("fade_to_black")


func _on_animation_player_animation_finished(_fade_to_black) -> void:
	get_tree().change_scene_to_file("res://world/world.tscn")
