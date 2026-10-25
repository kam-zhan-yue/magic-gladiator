extends Node3D

var _projectiles: Array[Projectile] = []
var _parent: Node3D

func init(parent_node: Node3D) -> void:
	_parent = parent_node

func add(projectile: Projectile):
	_parent.add_child(projectile)
	_projectiles.push_back(projectile)

func update(delta: float) -> void:
	for i in range(len(_projectiles) - 1, -1, -1):
		var projectile := _projectiles[i]
		projectile.alive_time -= delta
		if projectile.alive_time <= 0.0:
			projectile.queue_free()
			_projectiles.remove_at(i)
		else:
			projectile.simulate(delta)

func remove(projectile: Projectile) -> void:
	projectile.queue_free()
	_projectiles.erase(projectile)
