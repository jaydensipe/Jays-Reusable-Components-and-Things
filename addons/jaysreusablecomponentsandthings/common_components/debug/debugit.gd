extends Node

@export var debug_name: String
var _mouse_mode: Input.MouseMode = Input.MOUSE_MODE_CAPTURED
@onready var tree: Tree = $Panel/Tree

@onready var panel: Panel = $Panel
@onready var item_list: ItemList = $Panel/ItemList
var _item_lists: Array = []
var _current_exposed_node: Node = null
var _current_indicies: Array = []
var _tree_root

func _ready() -> void:
	panel.hide()
	_tree_root = tree.create_item()
	_tree_root.set_cell_mode(0, TreeItem.CELL_MODE_STRING)
	#var child1 = tree.create_item(root)
	#var child2 = tree.create_item(root)
	#var subchild1 = tree.create_item(child1)
	#subchild1.set_text(0, "Subchild1")
	

func _unhandled_key_input(event: InputEvent) -> void:
	if (event.is_action_pressed(debug_name)):
		if (_mouse_mode == Input.MOUSE_MODE_CAPTURED):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			_mouse_mode = Input.MOUSE_MODE_VISIBLE
			panel.show()
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			_mouse_mode = Input.MOUSE_MODE_CAPTURED
			panel.hide()
			
func register_section(title: String, node: Node, icon: Texture2D = null) -> int:
	var id: int = item_list.add_item(title, icon)
	var j = tree.create_item(_tree_root)
	j.set_text(0, title)
	j.set_icon(0, icon)
	_item_lists.insert(id, node.get_instance_id())
		
	return id
	
func _physics_process(delta: float) -> void:
	if (is_instance_valid(_current_exposed_node)):
		for index in len(_current_indicies):
			if (index == 0): continue
			item_list.set_item_text(index, _current_indicies[index] + " - " + str(_current_exposed_node.get(_current_indicies[index])))
	
func _on_item_list_item_selected(index: int) -> void:
	#for i in len(_current_indicies):
			#item_list.remove_item(i)
	
	_current_indicies.clear()
	_current_indicies.resize(500)
	if (!is_instance_id_valid(_item_lists[index])): return
	
	_current_exposed_node = instance_from_id(_item_lists[index])
	var count = 0
	for item in _current_exposed_node.get_property_list():
			if (item["usage"] == 4102 or item["usage"] == PROPERTY_USAGE_SCRIPT_VARIABLE):
				count+= 1
				_current_indicies[item_list.add_item("• " + item["name"] + " - " + str(_current_exposed_node.get(item["name"])), null, false)] = item["name"]
				
	_current_indicies.resize(count)
	_current_indicies = _current_indicies.filter(func(number): return number != null)
