extends Tree
class_name Inspector

var _tree_root: TreeItem
var _fallback_icon: Texture2D = preload("res://addons/jaysreusablecomponentsandthings/assets/icons/object.svg")
var _reset_icon: Texture2D = preload("res://addons/jaysreusablecomponentsandthings/assets/icons/reset.svg")

func _ready() -> void:
	columns = 2
	column_titles_visible = true
	allow_reselect = false
	allow_search = false
	hide_root = true
	column_titles_visible = false

	_tree_root = create_item()
	_tree_root.set_selectable(0, false)

func _physics_process(delta: float) -> void:
	if (is_instance_valid(_tree_root)):
		for child: TreeItem in _tree_root.get_children():
			_update_values_in_tree(child)

func _update_values_in_tree(root_node_tree_item: TreeItem):
	var current_node = instance_from_id(root_node_tree_item.get_meta(&"current_node_instance_id"))

	for var_row: TreeItem in root_node_tree_item.get_children():
		# TODO: Why?
		if (var_row.collapsed): return

		if (var_row.has_meta(&"current_node_instance_id")):
			_update_values_in_tree(var_row)
		else:
			var current_item_name = var_row.get_meta(&"current_item_name")
			var node_value = current_node.get(current_item_name)
			var prev_value = var_row.get_meta(&"prev_value")

			if (node_value != prev_value):
				var_row.set_custom_color(0, Color.YELLOW)
			else:
				var_row.set_custom_color(0, Color.GRAY)

			var_row.set_text(0, current_item_name)
			var_row.set_text(1, str(node_value))
			var_row.set_meta(&"prev_value", node_value)

func _register_inspector(node: Node, icon: Texture2D = null) -> void:
	var registered: TreeItem = create_item(_tree_root)
	var instance_id: int = node.get_instance_id()

	registered.set_text(0, node.to_string())
	registered.set_text(1, &"[Click to open]")
	registered.set_text_alignment(1, HORIZONTAL_ALIGNMENT_CENTER)
	registered.set_icon(0, icon)
	registered.set_icon_max_width(0, 32)
	registered.set_meta(&"current_node_instance_id", instance_id)

func _on_item_selected() -> void:
	var selected_tree_item: TreeItem = get_selected()
	if (!selected_tree_item.has_meta(&"current_node_instance_id")): return

	var current_node_instance_id = selected_tree_item.get_meta(&"current_node_instance_id")
	var current_node: Object = null

	if (current_node_instance_id == null):
		current_node = instance_from_id(selected_tree_item.get_parent().get_meta(&"current_node_instance_id"))
	else:
		current_node = instance_from_id(current_node_instance_id)

	for item: Dictionary in current_node.get_property_list():
		# item["usage"] == 6
		if (item["usage"] == PROPERTY_USAGE_STORAGE or item["usage"] == 4102 or item["usage"] == 69632 or item["usage"] == PROPERTY_USAGE_SCRIPT_VARIABLE):
			var child: TreeItem = get_selected().create_child()
			var item_name: StringName = item["name"]
			var value = current_node.get(item_name)

			_setup_child_tree_node_bg_color(child, item)

			if (is_instance_valid(value) and item["type"] == TYPE_OBJECT):
				child.set_text(0, value.to_string())
				child.set_text(1, &"[Click to open]")
				child.set_text_alignment(1, HORIZONTAL_ALIGNMENT_CENTER)
				child.set_icon(0, _fallback_icon)
				child.set_icon_max_width(0, 16)
				child.set_meta(&"current_node_instance_id", value.get_instance_id())
			else:
				child.set_text(0, item_name)
				child.set_meta(&"current_item_name", item_name)
				child.set_meta(&"prev_value", value)
				child.set_meta(&"default_value", value)
				child.set_editable(1, true)

				if (typeof(value) == TYPE_BOOL):
					child.set_cell_mode(1, TreeItem.CELL_MODE_CHECK)
					child.set_checked(1, value)

func _setup_child_tree_node_bg_color(child: TreeItem, item: Dictionary):
	match (item["usage"]):
		PROPERTY_USAGE_STORAGE:
			child.set_custom_bg_color(0, Color("#0B666A", 0.2))
		4102:
			child.set_custom_bg_color(0, Color("#071952",  0.2))
		69632:
			child.set_custom_bg_color(0, Color("#35A29F",  0.2))
		PROPERTY_USAGE_SCRIPT_VARIABLE:
			child.set_custom_bg_color(0, Color("#97FEED",  0.2))


func _on_item_edited() -> void:
	var selected_tree_item: TreeItem = get_selected()
	var cell_mode: TreeItem.TreeCellMode = selected_tree_item.get_cell_mode(1)
	var node = instance_from_id(selected_tree_item.get_parent().get_meta(&"current_node_instance_id"))

	if (!selected_tree_item.has_meta(&"current_item_name")): return

	var current_item_name = selected_tree_item.get_meta(&"current_item_name")
	var val = node.get(current_item_name)

	if (str_to_var(selected_tree_item.get_text(1)) == selected_tree_item.get_meta(&"default_value")):
		selected_tree_item.clear_custom_bg_color(1)
		selected_tree_item.erase_button(1, 0)
	elif(!is_instance_valid(selected_tree_item.get_button(1, 0))):
		selected_tree_item.add_button(1, _reset_icon, 0, false, "Reset")
		selected_tree_item.set_button_color(1, 0, Color.RED)

	match cell_mode:
		TreeItem.CELL_MODE_CHECK:
			node.set(current_item_name, !val)
			selected_tree_item.set_checked(1, !val)
		TreeItem.CELL_MODE_STRING:
			node.set(current_item_name, str_to_var(selected_tree_item.get_text(1)))
			selected_tree_item.set_text(1, str(val))


func _on_button_clicked(item: TreeItem, column: int, id: int, mouse_button_index: int) -> void:
	var cell_mode: TreeItem.TreeCellMode = item.get_cell_mode(1)
	var node = instance_from_id(item.get_parent().get_meta(&"current_node_instance_id"))
	var current_item_name = item.get_meta(&"current_item_name")
	var val = item.get_meta(&"default_value")

	item.clear_custom_bg_color(1)

	match cell_mode:
		TreeItem.CELL_MODE_CHECK:
			node.set(current_item_name, val)
			item.set_checked(1, val)
		TreeItem.CELL_MODE_STRING:
			node.set(current_item_name, val)
			item.set_text(1, str(val))

	item.erase_button(1, id)
