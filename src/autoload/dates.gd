extends Node

const DATE = preload("res://src/libraries/dates/datetime.gd")
const TIMESPAN = preload("res://src/libraries/dates/timespan.gd")

const WEEKDAYS = {
	Time.WEEKDAY_SUNDAY : "Sunday",
	Time.WEEKDAY_MONDAY : "Monday",
	Time.WEEKDAY_TUESDAY : "Tuesday",
	Time.WEEKDAY_WEDNESDAY : "Wednesday",
	Time.WEEKDAY_THURSDAY : "Thursday",
	Time.WEEKDAY_FRIDAY : "Friday",
	Time.WEEKDAY_SATURDAY : "Saturday"
}

const MINUTES_PER_HOUR : int = 60
const MINUTES_PER_DAY : int = 1440


static func get_new_date() -> DateTime:
	return DATE.new() as DateTime


static func get_date_from_ticks(ticks : int) -> DateTime:
	var date = get_new_date()
	date.ticks = ticks
# warning-ignore:integer_division
	date.day = (ticks / Dates.MINUTES_PER_DAY) % 7
# warning-ignore:integer_division
	date.hour = (ticks / Dates.MINUTES_PER_HOUR) % 24
	date.minute = ticks % 60
	return date


static func copy_datetime(other_datetime : DateTime) -> DateTime:
	var date = get_new_date()
	date.ticks = other_datetime.ticks
	date.day = other_datetime.day
	date.hour = other_datetime.hour
	date.minute = other_datetime.minute
	return date


static func generate_date(day : int, hour : int, minute : int) -> DateTime:
	var date = get_new_date()
	date.ticks = get_ticks(day, hour, minute)
	date.day = day
	date.hour = hour
	date.minute = minute
	return date


static func get_date_now() -> DateTime:
	var time = OS.get_datetime()
	var date = get_new_date()
	date.ticks = get_ticks(time.weekday, time.hour, time.minute)
	date.day = time.weekday
	date.hour = time.hour
	date.minute = time.minute
	return date
	

static func get_date_today() -> DateTime:
	var time = OS.get_datetime()
	var date = get_new_date()
	date.ticks = get_ticks(time.weekday, 0, 0)
	date.day = time.weekday
	return date
	
	
static func get_ticks(day : int, hour : int, minute : int) -> int:
	return day * MINUTES_PER_DAY + hour * MINUTES_PER_HOUR + minute


static func get_ticks_from_date(datetime : DateTime) -> int:
	var day : int  = datetime.day
	var hour : int = datetime.hour
	var minute : int = datetime.minute
	return get_ticks(day, hour, minute)

	
static func to_dictionary(datetime : DateTime) -> Dictionary:
	return {
		"ticks" : datetime.ticks,
		DateTime.DAY_KEY : datetime.day,
		DateTime.HOUR_KEY : datetime.hour,
		DateTime.MINUTE_KEY : datetime.minute,
	}


static func from_dictionary(date : Dictionary) -> DateTime:
	var datetime = get_new_date()
	if date.has("ticks"):
		datetime.ticks = date["ticks"]
	if date.has(DateTime.DAY_KEY):
		datetime.day = date[DateTime.DAY_KEY]
	if date.has(DateTime.HOUR_KEY):
		datetime.hour = date[DateTime.HOUR_KEY]
	if date.has(DateTime.MINUTE_KEY):
		datetime.minute = date[DateTime.MINUTE_KEY]
	return datetime


static func get_timespan(from : DateTime, to : DateTime, copy_datetimes : bool = false) -> TimeSpan:
	var timespan = TIMESPAN.new()
	if copy_datetimes:
		timespan.from_datetime = copy_datetime(from) as DateTime
		timespan.to_datetime = copy_datetime(to) as DateTime
	else:
		timespan.from_datetime = from
		timespan.to_datetime = to
	return timespan


static func generate_timespan(
		from_day : int = 0,
		from_hour : int = 0,
		from_minute : int = 0,
		to_day : int = 0, 
		to_hour : int = 0, 
		to_minute : int = 0) -> TimeSpan:
	var timespan = TIMESPAN.new()
	timespan.from_datetime = generate_date(from_day, from_hour, from_minute)
	timespan.to_datetime = generate_date(to_day, to_hour, to_minute)
	return timespan

	
static func generate_timespan_from_ticks(
		from_ticks : int = 0,
		to_ticks : int = 0) -> TimeSpan:
	var timespan = TIMESPAN.new()
	timespan.from_datetime = get_date_from_ticks(from_ticks)
	timespan.to_datetime = get_date_from_ticks(to_ticks)
	return timespan


static func generate_timespan_elapsed(
		from : DateTime,
		elapsed_days : int = 0, 
		elapsed_hours : int = 0, 
		elapsed_minutes : int = 0) -> TimeSpan:
	var timespan = TIMESPAN.new()
	timespan.from_datetime = copy_datetime(from) as DateTime
	var to_datetime = copy_datetime(from) as DateTime
	to_datetime.increment(elapsed_days * MINUTES_PER_DAY + elapsed_hours * MINUTES_PER_HOUR + elapsed_minutes)
	timespan.to_datetime = to_datetime
	return timespan
	

static func copy_timespan(timespan : TimeSpan, deep_copy : bool = true) -> TimeSpan:
	var new_timespan = TIMESPAN.new()
	if deep_copy:
		new_timespan.from_datetime = copy_datetime(timespan.from_datetime)
		new_timespan.to_datetime = copy_datetime(timespan.to_datetime)		
	else :
		new_timespan.from_datetime = timespan.from_datetime
		new_timespan.to_datetime = timespan.to_datetime
	return new_timespan
