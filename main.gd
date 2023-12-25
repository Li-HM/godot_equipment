extends Node2D

var static_data:Array

func _ready():
	if static_data.is_empty():
#		读取一个文件
		var json_file = FileAccess.open("res://resources/equipment.json",FileAccess.READ)
#		把json字符串解析成数组,反序列化
		static_data = JSON.parse_string(json_file.get_as_text())
		json_file.close()
		#print(静态数据)



#获得物品
func _on_get_items_button_down():
	backpack_grid.get_items({"name":"叶子","type":"crops","number":"5","icon":"00001"})
	backpack_grid.get_items({"name":"水果","type":"crops","number":"2","icon":"00002"})
	for i in static_data:
		if i["name"] == "阔刀":
			backpack_grid.get_items(i)
		if i["name"] == "双刃剑":
			backpack_grid.get_items(i)
		if i["name"] == "步枪":
			backpack_grid.get_items(i)
		if i["name"] == "白色的帽子":
			backpack_grid.get_items(i)
		if i["name"] == "绿色的帽子":
			backpack_grid.get_items(i)
		if i["name"] == "草鞋":
			backpack_grid.get_items(i)

#查看数据
func _on_view_data_button_down():
	print("=======背包数组========")
	print(backpack_grid.item_array)
	
	print("=======身上装备数组========")
	print(equipment.equipment_array)

#打开背包
func _on_open_ba_button_down():
	backpack_grid.open_backpack($my_backpack)
	equipment.open_equipment($my_equipment)

#关闭背包
func _on_close_ba_button_down():
	backpack_grid.close_backpack()
	equipment.close_equipment()
