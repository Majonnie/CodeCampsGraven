extends KinematicBody2D

var speed = 300
var direction = Vector2.ZERO

func _process(delta):
	var __ = move_and_slide(direction * speed)
	

func _input(event):
	
	direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	direction = direction.normalized() #Limite à 1 la direction (pour la vitesse en diagonale)
