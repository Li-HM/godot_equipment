extends Control

var grid_node:TextureRect = null  #记录装备栏格子

func _enter_tree():
	for i in self.find_children("*","TextureRect",false,true):
		#给装备格子挂上脚本
		var src = load("res://addons/equipment/grid.gd")
		i.set_script(src)



#鼠标点击事件
func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			#判断,如果正在拖动物品
			if backpack_grid.is_drag and backpack_grid.drag_item["type"] == "equipment"  :
				var weared:bool = false   #用于判断装备栏有没有装备这个类型的装备
				#先遍历穿戴数组有没有这个类型的装备
				for zb in equipment.equipment_array :
					if zb != null and  zb["subclass"] == backpack_grid.drag_item["subclass"] :
						weared = true
						break
				#遍历装备栏里面所有TextureRect节点
				for i in self.find_children("*","TextureRect",false,true):
					if i.get_meta("subclass") == backpack_grid.drag_item["subclass"] :
						#已经穿戴了这类装备，进行替换
						if weared:
							equipment.replace_equipment(i,i.get_meta("index"))
						#未穿戴这类装备，进行穿戴
						else :
							equipment.wear_equipment(i,i.get_meta("index"))
						#已经找到匹配的类型，跳出循环
						break
		_on_mouse_exited()



#鼠标进入控件
func _on_mouse_entered():
	#判断，如果有正在拖动的装备类型的物品，显示对应格子背景色
	for i in self.find_children("*","TextureRect",false,true):
		if backpack_grid.is_drag and backpack_grid.drag_item["type"] == "equipment" :
			if i.get_meta("subclass") == backpack_grid.drag_item["subclass"] :
				i.set_deferred("self_modulate","e4e98e")        
				grid_node = i


#鼠标离开控件
func _on_mouse_exited():
	if grid_node != null:
		grid_node.set_deferred("self_modulate","ffffff")


