extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var shoot = false
var mouse_sens = 0.002
var bullet_scene = preload("res://Bullet.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sens)

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("shoot"):
		if shoot == false:
			shoot = true
			var bullet = bullet_scene.instantiate()
			get_tree().root.add_child(bullet)
			bullet.global_transform = $Marker3D.global_transform
			$arms_beretta/AnimationPlayer.play("CINEMA_4D_Main")
			await get_tree().create_timer(0.4).timeout
			$arms_beretta/AnimationPlayer.stop()
			shoot = false
	
	var input_dir = Input.get_vector("ui_right", "ui_left", "ui_down", "ui_up")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
	else:
		
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
