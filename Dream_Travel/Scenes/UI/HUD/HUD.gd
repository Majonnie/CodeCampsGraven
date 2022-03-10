extends TextureRect

onready var coin_counter_label = $CoinCounter

func _ready():
	EVENTS.connect("nb_coins_changed", self, "_on_EVENTS_nb_coins_changed")


func _on_EVENTS_nb_coins_changed(nb_coins):
	coin_counter_label.set_text(String(nb_coins))
