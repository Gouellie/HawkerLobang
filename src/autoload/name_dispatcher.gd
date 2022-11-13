extends Node

const NAMES = {
	"chicken rice" : [
		"Sinn Ji",
		"Feng Ji",
		"Rong Ji",
		"Nan Heng",
		"Shun Rong Xing Tian Xi",
		"Xing Yun",
		"Pow Sing",
		"Tian Tian",
		"Ming Kee",
		"Chin Chin",
		"Hua Kee",
		"Kampong",
		"Nam Kee",
		"Boon Tong Kee",
		"Katong Mei Wei",
	],
	"carrot cake" : [
		"Fu Ming Cooked Food",
		"Chey Sua",
		"He Zhong",
		"Ghim Moh",
		"Lagoon",
		"Hock Soon",
	],
	"nasi lemak" : [
		"Changi",
		"Pak Mandor",
		"Nurul Delights",
		"Mizzy Corner",
		"Kedai Makan",
		"Selera Rasa",
		"Chong Pang",
		"Adimann",
		"Lawa Bintang",
		"Chai Chee",
	],
	"roti prata" : [
		"Casuarina Curry",
		"Springleaf",
		"Sin Ming",
		"Chindamani",
		"Mr and Mrs Mohgan’s",
		"The Roti Prata House",
		"Prata Wala",
		"Rahmath",
		"Mr Prata",
		"Niqqi's",
		"Al-Azhar",
		"Al-Ameen",
	]	
}

func get_random_name(dish_type : String) -> String:
	dish_type = dish_type.to_lower()
	if NAMES.has(dish_type):
		var list = NAMES[dish_type] as Array
		var r_index = randi() % list.size()
		return list[r_index]
	return ""
