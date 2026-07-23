extends Node


enum Level {
	DEBUG,
	INFO,
	WARNING,
	ERROR,
}

enum Verbosity {
	BRIEF,
	CALLER,
	STACK,
}

var level: Level


func _ready() -> void:
	Debug.level = Level.DEBUG


func debug(message: String, verbosity: Verbosity = Verbosity.BRIEF) -> void:
	var message_color: Color = Color.ROYAL_BLUE
	var trace_color: Color = Color.STEEL_BLUE
	
	if Debug.level <= Level.DEBUG:
		print_rich('[color=%s][b]• [DEBUG][/b] %s[/color]' % [message_color.to_html(false), message])
		_attach_stack_trace(verbosity, trace_color)


func info(message: String, verbosity: Verbosity = Verbosity.BRIEF) -> void:
	var message_color: Color = Color.MEDIUM_SEA_GREEN
	var trace_color: Color = Color.SEA_GREEN
	
	if Debug.level <= Level.INFO:
		print_rich('[color=%s][b]• [INFO][/b] %s[/color]' % [message_color.to_html(false), message])
		_attach_stack_trace(verbosity, trace_color)


func warning(message: String, verbosity: Verbosity = Verbosity.BRIEF) -> void:
	var message_color: Color = Color.ORANGE
	var trace_color: Color = Color.PERU
	
	if Debug.level <= Level.WARNING:
		print_rich('[color=%s][b]• [WARNING][/b] %s[/color]' % [message_color.to_html(false), message])
		_attach_stack_trace(verbosity, trace_color)


func error(message: String, verbosity: Verbosity = Verbosity.BRIEF) -> void:
	var message_color: Color = Color.CRIMSON
	var trace_color: Color = Color.WEB_MAROON
	
	if Debug.level <= Level.ERROR:
		print_rich('[color=%s][b]• [ERROR][/b] %s[/color]' % [message_color.to_html(false), message])
		_attach_stack_trace(verbosity, trace_color)


func _attach_stack_trace(verbosity: Verbosity = Verbosity.BRIEF, color: Color = Color.WHITE) -> void:
	var stack: Array[Dictionary] = get_stack()
	stack.reverse()
	
	match verbosity:
		Verbosity.CALLER:
			print_rich('  [color=%s][i]from[/i] [b]%s[/b]:[i]%d[/i]  (%s)[/color]' % [
				color.to_html(false), stack[0]['function'], stack[0]['line'], stack[0]['source'].split('/')[-1]
			])
		
		Verbosity.STACK:
			for caller: Dictionary in stack:
				print_rich('  [color=%s][i]from[/i] [b]%s[/b]:[i]%d[/i]  (%s)[/color]' % [
					color.to_html(false), caller['function'], caller['line'], caller['source'].split('/')[-1]
				])
