extends KinematicBody2D

onready var animated_sprite = get_node("AnimatedSprite")

enum STATE {    #permet de gérer l'état du personnage
	IDLE,
	MOVE,
	ATTACK,
}

var dir_dict: Dictionary = {    #dictionnaire permettant de gerer les mouvements du personnage 
	"Left": Vector2.LEFT,
	"Right": Vector2.RIGHT,
	"Up": Vector2.UP,
	"Down": Vector2.DOWN,
}

var state: int = STATE.IDLE setget set_state, get_state   #permet de changer la valeur de state et de récupérer la valeur de state

var speed = 150     # vitesse de déplacement 
var moving_direction := Vector2.ZERO  #mouvement du perso initialisé a 0
var facing_direction := Vector2.DOWN setget set_facing_direction, get_facing_direction  #direction du perso initialisé a DOWN

signal state_changed
signal facing_direction_changed

#### ACCESSORS ####

func set_state(value: int) -> void:
	if value != state:
		state = value
		emit_signal("state_changed")
	
func get_state() -> int:
	return state
	
func set_facing_direction(value: Vector2) -> void:
	if facing_direction != value:
		facing_direction = value
		emit_signal("facing_direction_changed")

func get_facing_direction() -> Vector2:
	return facing_direction

#### FONCTION DE GODOT####

func _process(_delta):    #permet au perso de se pdéplacer 
	var __ = move_and_slide(moving_direction * speed)
	

func _input(_event):
	
	moving_direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))   #permet de se déplacer horizontalement
	moving_direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))      #permet de se déplacé verticalement
	
	if moving_direction != Vector2.ZERO:    #si la direction de mouvement est différent de 0
		set_facing_direction(moving_direction)    #alors la direction du perso = au mouvement du perso
	
	moving_direction = moving_direction.normalized() #Limite à 1 la direction (pour la vitesse en diagonale)

	if Input.is_action_just_pressed("ui_accept"):  #si le bouton attack est appuyé 
		set_state(STATE.ATTACK)   #alors l'état du perso change en ATTACK
	

	if state != STATE.ATTACK:
		if moving_direction == Vector2.ZERO:
			set_state(STATE.IDLE)
		else:
			set_state(STATE.MOVE)

#### LOGIC SCRIPT ####

#### UPDATE THE ANIMATION BASED THE CURRENT STATE AND FACING_DIRECTION ####
func _update_animation() -> void:
	var dir_name = _find_dir_name(facing_direction)   #diR_name = a la direction du perso
	var state_name = ""
	
	match(state):
		STATE.IDLE: state_name = "Idle"
		STATE.MOVE: state_name = "Move"
		STATE.ATTACK: state_name = "Attack"
		
	animated_sprite.play(state_name + dir_name)

#### FIND THE NAME OF THE GIVEN DIRECTION AND RETURNS IT AS A STRING ####
func _find_dir_name(dir: Vector2) -> String:   #fonction permettant de trouver la direction du mouvement 
	var dir_values_array = dir_dict.values()
	var dir_index = dir_values_array.find(dir)
	if dir_index == -1:
		return ""
	var dir_keys_array = dir_dict.keys()
	var dir_key = dir_keys_array[dir_index]
	
	return dir_key

#### SIGNAL RESPONSES ####

func _on_AnimatedSprite_animation_finished() -> void:    #fonction qui permet de gerer l'animation des attaques
	if "Attack".is_subsequence_of(animated_sprite.get_animation()): #si il y a le mot attaque dans l'animation
		set_state(STATE.IDLE)

func _on_state_changed():   #fonction qui va être appelé a chaque fois que staten change de value 
	_update_animation()

func _on_facing_direction_changed():   #fonction qui va être appelé a chaque fois que la direction de la caméra change de value 
	_update_animation()


func _on_moving_direction_changed() -> void:
	if moving_direction == Vector2.ZERO or moving_direction == facing_direction:
		return 


func _on_AnimatedSprite_frame_changed():
	pass # Replace with function body.


func _on_Character_facing_direction_changed():
	pass # Replace with function body.


func _on_Level_body_entered(body) -> void:
	get_tree().change_scene("res://Scenes/Levels/Level1.tscn")


func _on_Level1_body_entered(body):
	get_tree().change_scene("res://Scenes/Levels/Level2.tscn")


func _on_Level2_body_entered(body):
	get_tree().change_scene("res://Scenes/Levels/Level3.tscn")


func _on_Level3_body_entered(body):
	get_tree().change_scene("res://Scenes/Levels/Level4.tscn")


func _on_Level4_body_entered(body):
	get_tree().change_scene("res://Scenes/Levels/LevelBoss.tscn")
