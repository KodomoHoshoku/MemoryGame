extends Control

var main_menu = load("res://src/main_menu/MainMenu.tscn")

onready var card_cont = $Panel/HBoxContainer/gridcont/CenterContainer/GridContainer

onready var p1sl = $Panel/HBoxContainer/p1cont/MarginContainer/VBoxContainer/P1ScoreLabel
onready var p2sl = $Panel/HBoxContainer/p2cont/MarginContainer/VBoxContainer/P2ScoreLabel

onready var yt1 = $Panel/HBoxContainer/p1cont/MarginContainer/VBoxContainer/YT1
onready var yt2 = $Panel/HBoxContainer/p2cont/MarginContainer/VBoxContainer/YT2

onready var popo = $AcceptDialog

var player_turn = 1
var p1s = 0
var p2s = 0

var default_texture = preload("res://assets/sets/default.png")

var cs = 0

var last_clicked_id = null
var last_clicked_node = null

var is_on_yield = false

var card_sets = [
	[
		preload("res://assets/sets/set_fruits/tile000.png"),
		preload("res://assets/sets/set_fruits/tile001.png"),
		preload("res://assets/sets/set_fruits/tile002.png"),
		preload("res://assets/sets/set_fruits/tile003.png"),
		preload("res://assets/sets/set_fruits/tile004.png"),
		preload("res://assets/sets/set_fruits/tile006.png"),
		preload("res://assets/sets/set_fruits/tile008.png"),
		preload("res://assets/sets/set_fruits/tile009.png"),
		preload("res://assets/sets/set_fruits/tile010.png"),
		preload("res://assets/sets/set_fruits/tile012.png"),
		preload("res://assets/sets/set_fruits/tile013.png"),
		preload("res://assets/sets/set_fruits/tile014.png"),
		preload("res://assets/sets/set_fruits/tile015.png"),
		preload("res://assets/sets/set_fruits/tile020.png"),
		preload("res://assets/sets/set_fruits/tile024.png"),
		preload("res://assets/sets/set_fruits/tile025.png"),
		preload("res://assets/sets/set_fruits/tile026.png"),
		preload("res://assets/sets/set_fruits/tile027.png")
	]
]

var card_order = []

func _ready():
	randomize()
	for i in range(0,36):
		card_order.append(i)
	for i in range(0,36):
		var r = randi() % 36
		var a = card_order[i]
		card_order[i] = card_order[r]
		card_order[r] = a
	
	for i in range(0,36):
		var card = TextureButton.new()
		card.expand = true
		card.texture_normal = default_texture
		card.rect_min_size = Vector2(70, 70)
		card.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		card.connect("pressed", self, "card_click", [card_order[i], card])
		card_cont.add_child(card)

func card_click(id: int, node: TextureButton):
	if (is_on_yield == true):
		return
	if(last_clicked_id == null):
		last_clicked_id = id
		last_clicked_node = node
		var t = 0
		if (id <= 17):
			t = id
		else:
			t = 35 - id
		node.texture_normal = card_sets[cs][t]
	else:
		if(last_clicked_id == id):
			return 
		var t = 0
		if (id <= 17):
			t = id
		else:
			t = 35 - id
		node.texture_normal = card_sets[cs][t]
		if (last_clicked_id + id == 35):
			node.disconnect("pressed", self, "card_click")
			last_clicked_node.disconnect("pressed", self, "card_click")
			self["p" + String(player_turn) + "s"] += 1
			self["p" + String(player_turn) + "sl"].text = "Score: " + String(self["p" + String(player_turn) + "s"])
			if (p1s + p2s == 18):
				if (p1s > p2s):
					# p1 ..
					popo.dialog_text = "Player 1 WON!"
					pass
				if (p1s < p2s):
					popo.dialog_text = "Player 2 WON!"
					pass
					# p2
				if (p1s == p2s):
					popo.dialog_text = "It's a DRAW!"
					pass
					# draw
				popo.popup_centered()
				popo.popup()
				return
		else: 
			is_on_yield = true
			yield(get_tree().create_timer(1.0), "timeout")
			is_on_yield = false
			node.texture_normal = default_texture
			last_clicked_node.texture_normal = default_texture
			yt1.visible = false
			yt2.visible = false
			if (player_turn == 1):
				player_turn = 2
				yt2.visible = true
			else:
				player_turn = 1
				yt1.visible = true
		last_clicked_id = null
		last_clicked_node = null


func _on_AcceptDialog_confirmed():
	get_tree().change_scene_to(main_menu)
	pass # Replace with function body.
