extends Control


func _ready():
	Jukebox._play_music()


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://world/world.tscn")
