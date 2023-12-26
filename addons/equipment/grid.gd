extends Control

func _ready():
	#连接鼠标进入和离开信号
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)


#鼠标点击事件
func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.is_released():
			#判断,如果没有拖动物品
			if !backpack_grid.is_drag:
				_on_mouse_exited()
				popup_button()


#鼠标进入装备栏的格子
func _on_mouse_entered():
	if self.get_meta("is_equ"):
		#创建详情页
		var attribute = preload("res://addons/backpack_grid/item_info.tscn").instantiate()
		get_node("/root/backpack_grid").add_child(attribute)
		attribute.global_position = self.global_position + backpack_grid.item_grid_xp/1.3
		attribute.z_index = backpack_grid.zz_index+3
		for i in equipment.equipment_array[self.get_meta("index")]:
			if i != "icon" :
				#把默认的栏目设置为name
				if i == "name" :
					attribute.get_node("BoxContainer/name").text = equipment.equipment_array[self.get_meta("index")][i]
				else :
					var type = attribute.get_node("BoxContainer/name").duplicate()
					type.text = i +" : "+str(equipment.equipment_array[self.get_meta("index")][i])
					attribute.get_node("BoxContainer").add_child(type)
		attribute.size.y = (26 + attribute.get_node("BoxContainer").get_child_count() * 26)


#鼠标离开装备栏的格子
func _on_mouse_exited():
	#	关闭详情页
	if has_node("/root/backpack_grid/item_info"):
		get_node("/root/backpack_grid/item_info").free()


#鼠标右键点击装备栏装备，弹出“卸下”按钮
func popup_button():
	var equ_button = preload("res://addons/equipment/equ_button.tscn").instantiate()
	#判断，删除上一个按钮
	if equipment.equipment_parent_node.get_child(-1) is Button:
		equipment.equipment_parent_node.get_child(-1).queue_free()
	equipment.equipment_parent_node.add_child(equ_button)
	equ_button.global_position = self.global_position + backpack_grid.item_grid_xp/1.7
	equ_button.z_index = backpack_grid.zz_index+2
	equ_button.equ_index = self.get_meta("index")
	equ_button.equ_Association_Node = self
	equ_button.equ_dic = equipment.equipment_array[self.get_meta("index")]
	


