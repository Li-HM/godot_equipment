extends Button

#关联图标节点
var equ_Association_Node:TextureRect
var equ_index:int
var equ_dic:Dictionary

func _on_button_down():
	##1、数据转移回背包; 2、减去对应属性； 3、删除装备栏数据; 4、删除图标和按钮
	#数据转移回背包
	backpack_grid.get_items(equ_dic)
	#减去对应属性值
	equipment.attribute_reduce(equ_dic)
	#删除装备栏数据
	equipment.equipment_array[equ_index] = null
	#删除图标和按钮
	equ_Association_Node.set_meta("is_equ",false)
	equ_Association_Node.get_child(-1).queue_free()
	self.queue_free()
