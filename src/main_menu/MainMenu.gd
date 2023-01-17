extends Control

const main_game = preload("res://src/game_scene/GameScene.tscn")

onready var rules_dialog = $AcceptDialog

func _ready():
	pass

func _on_StartBTN_pressed():
	get_tree().change_scene_to(main_game)

func _on_RulesBTN_pressed():
	rules_dialog.popup()

func _on_QuitBTN_pressed():
	get_tree().quit()
