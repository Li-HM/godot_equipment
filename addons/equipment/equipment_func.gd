extends Node

#===============参数设置=============
var equipment_array:Array = []   #装备栏数组
var grid_sum:int  =  3      #装备栏上的格子数量，这会和装备栏数组挂钩
var attribute_array:Array = []    #属性数组
var equipment_icon_route:String =  "res://resources/images/"  #背包物品图标,添加添加多个目录时，需要在加载背包创建图标时进行路径判断
var equipment_parent_node:Node = null  #指定一个父节点，背包会生成在父节点中。这意味着第一行的全局位置会失效
var equipment_status:bool  = false    #装备栏状态
#===============参数设置-结束=============


func _ready():
	#设置数组的长度
	equipment_array.resize(grid_sum)


#打开装备栏
func open_equipment(eq_Parent:Node):
	equipment_parent_node = eq_Parent
	if equipment_status:
		return
	equipment_status = true
	#实例化装备栏节点
	var equ = preload("res://addons/equipment/equipment_interface.tscn").instantiate()
	equ.name = "equipment"
	equipment_parent_node.add_child(equ)
	equ.set_deferred("size",equipment_parent_node.size)
	equ.position = Vector2.ZERO
	#调用数据加载
	load_data_equipment()
	

#关闭装备栏
func close_equipment():
	if equipment_status:
		equipment_parent_node.get_child(-1).queue_free()
		equipment_status = false


#加载装备栏数据
func load_data_equipment():
	for i in equipment_array:
		if i != null:
			#加载装备图标
			#遍历装备栏格子
			var drid_node = equipment_parent_node.get_node("equipment")
			for grid in drid_node.find_children("*","TextureRect",false,true):
				if grid.get_meta("subclass") == i["subclass"] :
					var items = preload("res://addons/backpack_grid/item_node.tscn").instantiate()
					grid.add_child(items)
					#设置参数，表示这个格子有东西
					grid.set_meta("is_equ",true)
					items.get_node("TextureRect").size = backpack_grid.item_grid_xp - Vector2(2,2)
#					设置物品图标和显示名称
					if ResourceLoader.exists(equipment.equipment_icon_route + str(i["icon"]) + str(".png")):
						items.get_node("TextureRect").texture = load(equipment.equipment_icon_route + str(i["icon"]) + str(".png"))
					items.get_node("name").text = str(i["name"])
#					如果图标上的数量或名称有位移或偏差，调整这里
					items.get_node("name").size = Vector2(backpack_grid.item_grid_xp.x,26)
					items.get_node("name").position = Vector2(0,backpack_grid.item_grid_xp.y-26)
					items.get_node("number").text = ""


#替换装备，参数是父节点
func replace_equipment(parent:TextureRect,index):
	#先把身上的装备放回背包。#1、移除实例； #2、数据转移回背包，并删除装备栏数据  3,把拖动的装备穿上
	parent.get_child(-1).queue_free()
	backpack_grid.get_items(equipment_array[index])
	#减去对应属性值
	attribute_reduce(equipment_array[index])
	equipment_array[index] = null
	#再把拿着的装备穿上
	wear_equipment(parent,index)


#佩戴装备,参数是父节点
func wear_equipment(parent:TextureRect,index):
	equipment_array[index] = backpack_grid.drag_item
	#添加这个装备的属性
	attribute_increase(backpack_grid.drag_item)
	backpack_grid.is_drag = false
	backpack_grid.drag_item = {}
	parent.set_meta("is_equ",true)
	#把物品的实例放到装备栏
	if has_node("/root/backpack_grid/item_node"):
		get_node("/root/backpack_grid/item_node").reparent(parent)
		parent.get_child(-1).position = Vector2.ZERO


#属性增加，即穿装备。传入的是整件装备的字典，需要根据自己游戏的需求进行计算
func attribute_increase(item:Dictionary):
	pass
#属性减少，即卸载装备。传入的是整件装备的字典，需要根据自己游戏的需求进行计算
func attribute_reduce(item:Dictionary):
	pass
