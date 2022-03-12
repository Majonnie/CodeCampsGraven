extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/Continue.grab_focus()



func _on_Continue_pressed():
	get_tree().change_scene("res://Scenes/Levels/Chambre_de_Charly.tscn")


func _on_New_Game_pressed():
	get_tree().change_scene("res://Scenes/Levels/Chambre_de_Charly.tscn")


func _on_Quit_pressed():
	get_tree().quit()
