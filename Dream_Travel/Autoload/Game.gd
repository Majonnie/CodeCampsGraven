extends Node

var nb_coins = 0 setget set_nb_coins, get_nb_coins


func set_nb_coins(value):
	if value != nb_coins:
		nb_coins = value
		EVENTS.emit_signal("nb_coins_changed", nb_coins)


func get_nb_coins():
	return nb_coins


func _ready():
	EVENTS.connect("coin_collected", self, "_on_EVENTS_coin_collected")


func _on_EVENTS_coin_collected():
	set_nb_coins(nb_coins + 100)
