extends Area3D



var speed = 20
var lifetime = 1
var damage = 20

func _ready():
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta):
	position += transform.basis.z * speed * delta

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
