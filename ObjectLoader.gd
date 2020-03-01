extends TileMap

class_name ObjectLoader

export( String, DIR ) var obj_directory

func _ready():
	add_objects()

# Method for adding objects.
func add_objects():
	
	# Cell Size
	var cs_x = self.cell_size.x
	var cs_y = self.cell_size.y
	
	# Array containing positions of used tiles.
	var used_cells = self.get_used_cells()
	
	for position in used_cells :
		
		# Position of current tile
		var pos_x = position.x
		var pos_y = position.y
		
		# Name of current tile.
		var name = tile_set.tile_get_name( get_cell( pos_x, pos_y ) )
		
		# Absolute path of an object with same name as tile name.
		var obj_path = obj_directory + "/" + name + ".tscn"
		
		# File - Used for file "Read"/"Write" operations.  
		var file = File.new()
		
		# Checking if object file exist.
		if file.file_exists( obj_path ):
			
			# Instance (Copy) of object.
			var obj = load( obj_path ).instance()
			
			# Position of an object.
			var obj_pos_x = pos_x * cs_x + ( cs_x / 2 )
			var obj_pos_y = pos_y * cs_y + ( cs_y / 2 )
			
			# Setting position of object.
			obj.position = Vector2( obj_pos_x,  obj_pos_y )
			
			var is_transposed = is_cell_transposed( pos_x, pos_y )
			var flipped_x = is_cell_x_flipped( pos_x, pos_y )
			var flipped_y = is_cell_y_flipped( pos_x, pos_y )
			
			# Setting Rotation and Flip(X/Y) of and object.
			if is_transposed:
				if flipped_x and flipped_y:
					obj.rotation_degrees = 90
					obj.scale.x = -obj.scale.x
				elif flipped_x:
					obj.rotation_degrees = 90
				elif flipped_y:
					obj.rotation_degrees = 270
				else:
					obj.rotation_degrees = 270
					obj.scale.x = -obj.scale.x
			else:
				if flipped_x:
					obj.scale.x = -obj.scale.x
				if flipped_y:
					obj.scale.y = -obj.scale.y
				
			# Adding an object in parent_node(Default: self)
			add_child( obj )
			
			# Deleting Tile
			set_cell( pos_x, pos_y, -1 )
