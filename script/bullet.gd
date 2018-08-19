extends RigidBody2D

func _on_bullet_body_enter( body ):
	if body.has_method("hit_by_bullet"):
		body.call("hit_by_bullet")
	if body.has_method("hitByBullet"):
		body.call("hitByBullet")
	queue_free()

func _on_Timer_timeout():
	$anim.play("shutdown")
