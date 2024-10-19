extends CharacterBody3D


var speed = 3
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var health = 100
var player
var is_attacking = false
var detection_range = 100
var attack_range = 1.3
var can_attack = true

func _ready():
	player = get_tree().get_first_node_in_group("player")
	$zombo/AnimationPlayer.play("Armature|Idle")

func _physics_process(delta):
	if health <= 0:
		queue_free()
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if player and !is_attacking:
		var distance = global_position.distance_to(player.global_position)
		var direction_to_player = player.global_position - global_position
		
		look_at(global_position + direction_to_player, Vector3.UP)
		rotate_y(PI)
		
		
		if distance <= detection_range:
			if distance > attack_range:
				var direction = (player.global_position - global_position).normalized()
				velocity.x = direction.x * speed
				velocity.z = direction.z * speed
				$zombo/AnimationPlayer.play("Armature|Walk2")
			else:
				velocity.x = move_toward(velocity.x, 0, speed)
				velocity.z = move_toward(velocity.z, 0, speed)
				attack()
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)
			$zombo/AnimationPlayer.play("Armature|Idle")
	
	move_and_slide()

func attack():
	if can_attack and !is_attacking:
		can_attack = false
		is_attacking = true
		$zombo/AnimationPlayer.play("Armature|Attack")
		
		await get_tree().create_timer(1).timeout
		can_attack = true
		is_attacking = false

func take_damage(x):
	health -= x
	print(health)
