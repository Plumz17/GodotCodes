@tool

extends Container
class_name DiagonalContainer

@export var x_dev: float = 10.0:
	set(value):
		x_dev = value
		queue_sort() #Force Editor to fixed layout
		
@export var y_dev: float = 10.0:
	set(value):
		y_dev = value
		queue_sort()

func _notification(what):
	if what == NOTIFICATION_SORT_CHILDREN:
		var count: int = 0
		# Must re-sort the children
		for c in get_children():
			c.position = Vector2(count * x_dev, count * y_dev)
			count += 1
