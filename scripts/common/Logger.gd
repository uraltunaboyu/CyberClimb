class_name Logger extends Node

enum LogLevel {
	DEBUG,
	INFO,
	WARN,
	ERROR
}

@onready var _instance: Logger = Logger.new()
const LOG_LEVEL = LogLevel.DEBUG

func _log(level: LogLevel, message: String):
	if level < LOG_LEVEL:
		return
	
	match level:
		LogLevel.DEBUG:
			print("DEBUG: " + message)
		LogLevel.INFO:
			print("INFO: " + message)
		LogLevel.WARN:
			print("WARN: " + message)
		LogLevel.ERROR:
			print("ERROR: " + message)
			
func Debug(message: String):
	_instance._log(LogLevel.DEBUG, message)
	
func Info(message: String):
	_instance._log(LogLevel.INFO, message)
	
func Warn(message: String):
	_instance._log(LogLevel.WARN, message)
	
func Error(message: String):
	_instance._log(LogLevel.ERROR, message)
	
