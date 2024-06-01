extends RefCounted
class_name LogIt

# Simple logger implementation
static func debug(message: Variant) -> void:
	print_rich("%s %s [color=orange][b][%s][/b][/color] - [color=lightblue][u]%s[/u]:%s[/color] [indent][color=white][DEBUG][/color] %s" % [Time.get_date_string_from_system(), Time.get_time_string_from_system(), get_stack()[1]["source"], get_stack()[1]["function"], get_stack()[1]["line"], str(message)])

static func info(message: Variant) -> void:
	print_rich("%s %s [color=orange][b][%s][/b][/color] - [color=lightblue][u]%s[/u]:%s[/color] [indent][color=cyan][INFO][/color] %s" % [Time.get_date_string_from_system(), Time.get_time_string_from_system(), get_stack()[1]["source"], get_stack()[1]["function"], get_stack()[1]["line"], str(message)])

static func warn(message: Variant) -> void:
	print_rich("%s %s [color=orange][b][%s][/b][/color] - [color=lightblue][u]%s[/u]:%s[/color] [indent][color=yellow][WARN][/color] %s" % [Time.get_date_string_from_system(), Time.get_time_string_from_system(), get_stack()[1]["source"], get_stack()[1]["function"], get_stack()[1]["line"], str(message)])
	push_warning(message)

static func error(message: Variant, throw_assert: bool = false) -> void:
	print_rich("%s %s [color=orange][b][%s][/b][/color] - [color=lightblue][u]%s[/u]:%s[/color] [indent][color=red][ERROR][/color] %s" % [Time.get_date_string_from_system(), Time.get_time_string_from_system(), get_stack()[1]["source"], get_stack()[1]["function"], get_stack()[1]["line"], str(message)])
	push_error(message)
	print_stack()

	if (throw_assert): assert(false, str(message))
