class_name MainMenu
extends Control


@onready var play_button = $PlayButton as Button
@onready var how_to_play = $HowToPlay as Button
@onready var play = preload("res://outside.tscn") as PackedScene
@onready var text = $Text
@onready var text_background = $Text/TextBackground
@onready var close_text = $CloseText

func _ready():
	play_button.button_down.connect(on_play_pressed)
	how_to_play.button_down.connect(on_how_to_play_pressed)
	close_text.button_down.connect(on_close_text_pressed)
func on_play_pressed() -> void:
	get_tree().change_scene_to_packed(play)
	
func on_how_to_play_pressed() -> void:
	text.set_visible(true)
	text_background.set_visible(true)
	close_text.set_visible(true)
func on_close_text_pressed() -> void:
	text.set_visible(false)
	text_background.set_visible(false)
	close_text.set_visible(false)
