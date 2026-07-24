class_name HurtComponent extends Area2D

signal hit(hit_data : int)

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("get_hit_data"):
		var data : int = area.get_hit_data()
		hit.emit(data)
