extends Node2D

enum STATE {
	IDLE,
	FOLLOW,
	COLLECT
}

onready var coin_sprite = $CoinSprite
onready var particules = $CPUParticles2D
onready var audio_stream = $AudioStreamPlayer2D

var state = STATE.IDLE
var target = null
var speed = 200.0


func _physics_process(delta):
	if state == STATE.FOLLOW:
		var target_pos = target.get_position()
		var spd = speed * delta
		
		if position.distance_to(target_pos) < spd:
			position = target_pos
			collect()
		else:
			position = position.move_toward(target_pos, spd)


func _on_Area2D_body_entered(body):
	if state == STATE.IDLE:
		state = STATE.FOLLOW
		target = body


func collect():
	state = STATE.COLLECT
	coin_sprite.visible = false
	particules.set_emitting(true)
	audio_stream.play()
	
	EVENTS.emit_signal("coin_collected")
	
	yield(audio_stream, "finished")
	
	queue_free()


func _on_Timer_timeout():
	if state == STATE.IDLE:
		coin_sprite.play("Rotation")


func _on_CoinSprite_animation_finished():
	if coin_sprite.get_animation() == "Rotation":
		coin_sprite.play("Idle")
