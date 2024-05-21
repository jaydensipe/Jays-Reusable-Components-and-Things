extends Node

@export var debug_name: String
var _mouse_mode: Input.MouseMode = Input.MOUSE_MODE_CAPTURED

@onready var panel: Panel = $Panel
@onready var tree: Tree = $Panel/Tree
var _tree_root: TreeItem

func _ready() -> void:
	panel.hide()
	_tree_root = tree.create_item()
	_tree_root.set_selectable(0, false)

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
			
func register_section(node: Node, icon: Texture2D = null) -> void:
	var regsitered: TreeItem = tree.create_item(_tree_root)
	regsitered.set_text(0, "%s:<%s#%d>" % [node.name, node.name, node.get_instance_id()])
	regsitered.set_icon(0, icon)
	regsitered.set_icon_max_width(0, 35)
	regsitered.set_meta("current_node_id", node.get_instance_id())
	
func _on_tree_item_selected() -> void:
	Loggit.info("Tree selected!")
	var current_node = instance_from_id(tree.get_selected().get_meta("current_node_id"))
	
	for item: Dictionary in current_node.get_property_list():
			if (item["usage"] == 4102 or item["usage"] == PROPERTY_USAGE_SCRIPT_VARIABLE):
				var child = tree.get_selected().create_child()
				child.set_selectable(0, false)
				child.set_text(0, item["name"] + " - " + str(current_node.get(item["name"])))
				child.set_meta("current_var", item["name"])
	
func _physics_process(delta: float) -> void:
	if (is_instance_valid(_tree_root) and panel.visible):
		for child: TreeItem in _tree_root.get_children():
			if (child.collapsed): return
			var current_node: Node = instance_from_id(child.get_meta("current_node_id"))
			for var_row: TreeItem in child.get_children():
				var_row.set_text(0, var_row.get_meta("current_var") + " - " + str(current_node.get(var_row.get_meta("current_var"))))
