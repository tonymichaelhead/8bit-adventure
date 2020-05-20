extends KinematicBody2D
class_name Player

export var ACCELERATION = 2000
export var MAX_SPEED = 150
export var FRICTION = 2000

enum {
	MOVE,
	JUMP,
	ATTACK,
}

var state  = MOVE
var velocity = Vector2.ZERO
var last_move_direction = Vector2.RIGHT
var sprite_direction = "down"
var attack_in_progress
var stats = PlayerStats

onready var animationPlayer := $AnimationPlayer
onready var animationTree := $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var hurtbox := $Hurtbox

onready var sword := $WeaponPivot/Sword

func _ready():
	stats.connect("no_health", self, "queue_free")
	animationTree.active = true
	sword.knockback_vector = last_move_direction
	
func _process(dt):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
func _physics_process(dt):
	match state:
		MOVE:
			move_state(dt)
		JUMP:
			pass
		ATTACK:
			attack_state(dt)

func move_state(dt):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	

	if input_vector != Vector2.ZERO:
		if input_vector != last_move_direction:
			last_move_direction = input_vector
			sword.knockback_vector = input_vector
			update_sprite_direction()
		
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * dt)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * dt)

	velocity = move_and_slide(velocity)

	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
func update_sprite_direction():
	match last_move_direction:
		Vector2(-1, 0):
			sprite_direction = "left"
		Vector2(1, 0):
			sprite_direction = "right"
		Vector2(0, -1):
			sprite_direction = "up"
		Vector2(0, 1):
			sprite_direction = "down"

func attack_state(dt):
	if !attack_in_progress:
		velocity = Vector2.ZERO
		animationState.travel("Attack")
		sword.attack(sprite_direction)
		attack_in_progress = true

func attack_animation_finished():
	print('attack animation finished heyy')
	state = MOVE
	attack_in_progress = false


func _on_Hurtbox_area_entered(area):
	stats.health -= 1
	hurtbox.start_invincibility(0.5)
	hurtbox.create_hit_effect()
