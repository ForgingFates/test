extends Node
#note to future self you probably either didnt need a global script at all and should have confined it all to the player
#or you should have put more of the code located in the player script here which is probably more efficient
#for orginizational purposes.
@onready var playerhealth = 100
@onready var playerdmg = 5
@onready var enemydmg :int
@onready var cur_zone 
@onready var prev_zone = "sec1"

	
#=====================================
#Enemy position dictionary - (im not sure if this is efficent or the final method
#I feel like If i knew more i could seperate the dictionaries into zones to be loaded seperatly 
#it might not be needed in a 2d game as small as this but who knows how it effects resources.)
#=====================================

