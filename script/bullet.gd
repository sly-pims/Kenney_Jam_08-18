extends RigidBody2D

var playerOwner

func _on_bullet_body_enter( body ):
	if body.has_method("hit_by_bullet"):
		body.call("hit_by_bullet")
	if body.has_method("hitByBullet"):
		body.call("hitByBullet")
	$CollisionShape2D.disabled = true
	$anim.play("shutdown")
	if body.get('lifeTime') != null:
		if body.get('lifeTime') > 0:
			playerOwner.lifeTime += 2