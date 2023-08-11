extends CharacterBody3D

#Troque<camera> e <$camera> pelo nome real da sua node da child node câmera3D abaixo! 
@onready var camera = $camera
#Troque o caminho <$visuals/mixamo_base/AnimationPlayer> pelo seu real AnimationPlayer abaixo!
@onready var animation_player = $visuals/mixamo_base/AnimationPlayer
#Troque o <visuals> pelo seu nome da sua node3D do character abaixo!
@onready var visuals = $visuals
#Gravidade
var SPEED = 3.0
const JUMP_VELOCITY = 4.5

var walking_speed = 3.0
var running_speed = 5.0

var running = false

#Sensibilidades
@export var sens_horizontal = 0.5
@export var sens_vertical = 0.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x*sens_horizontal))
		visuals.rotate_y(deg_to_rad(event.relative.x*sens_horizontal))
		#Troque a <camera> pelo nome real da sua node da child node câmera3D abaixo!
		camera.rotate_x(deg_to_rad(-event.relative.y*sens_vertical))
		

func _physics_process(delta):
	
	if Input.is_action_just_pressed("run"):
		SPEED = running_speed
		running = true
	else:
		SPEED = walking_speed
		running = false
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#Lembre de trocar <left = a><right = d><forward = w><backward = s>
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if running:
			if animation_player.current_animation != "running":
				animation_player.play("running")
			
		else: 
			if animation_player.current_animation != "walking":
				animation_player.play("walking")
			
		visuals.look_at(position + direction)
			
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		if animation_player.current_animation != "idle":
			animation_player.play("idle")
			
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
