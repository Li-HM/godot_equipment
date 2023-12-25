@tool
extends EditorPlugin

const zzxxcc = "equipment"

func _enter_tree():
	# Initialization of the plugin goes here.
	add_autoload_singleton(zzxxcc,"res://addons/equipment/equipment_func.gd")
	pass

func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_autoload_singleton(zzxxcc)
	pass


