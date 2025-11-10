require_relative 'cell.rb'
require_relative 'evaluate.rb'
require_relative 'serialize.rb'
require_relative 'vex_ast.rb'

class Grid
    attr_reader :x_axis_size
    attr_reader :y_axis_size
    attr_reader :grid_array_2d
    attr_reader :runtime

    #Create the grid.
    def initialize(grid_x_size, grid_y_size)
      @x_axis_size = grid_x_size
      @y_axis_size = grid_y_size
      @grid_array_2d = Array.new(grid_x_size - 1) #Initialize Grid's X-Axis
      for i in (0..grid_array_2d.length)
        grid_array_2d[i] = Array.new(grid_y_size) #Initialize Grid's Y-Axis
      end
    end

    #Set the grid runtime that we're going to use.
    def set_runtime(runtime)
      @runtime = runtime
    end

    #Get the cell.
    def get_cell(x_coord, y_coord)
      if x_coord > x_axis_size - 1 || x_coord < 0
        raise "Illegal X coordinate."
      end
      if y_coord > y_axis_size - 1 || y_coord < 0
        raise "Illegal Y coordinate."
      end
      ret_val = grid_array_2d[x_coord][y_coord]
    end

    #Set a cell. When set, the node will be evaluated.
    def set_cell(x_coord, y_coord, node)
      if x_coord > x_axis_size - 1 || x_coord < 0
        raise "Illegal X coordinate."
      end
      if y_coord > y_axis_size - 1 || y_coord < 0
        raise "Illegal Y coordinate."
      end
      grid_array_2d[x_coord][y_coord] = Cell.new
      ast_eval = Evaluate.new(runtime)
      most_recent_primitive = ast_eval.visit(node)
      grid_array_2d[x_coord][y_coord].set_most_recent_primitive(most_recent_primitive)
      ast_serialize = Serialize.new
      serialized_ast = ast_serialize.visit(node)
      grid_array_2d[x_coord][y_coord].set_string_rep(serialized_ast)
      grid_array_2d[x_coord][y_coord].set_held_AST(node)
    end

    #Add a cell variable to this cell's runtime.
    def add_cell_variable(x_coord, y_coord, variable, node)
      if x_coord > x_axis_size - 1 || x_coord < 0
        raise "Illegal X coordinate."
      end
      if y_coord > y_axis_size - 1 || y_coord < 0
        raise "Illegal Y coordinate."
      end
      if grid_array_2d[x_coord][y_coord] == nil
        grid_array_2d[x_coord][y_coord] = Cell.new
      end
      grid_array_2d[x_coord][y_coord].set_variable(variable, node)
    end

    #Get a cell variable from this cell's runtime.
    def get_cell_variable(x_coord, y_coord, variable)
      if x_coord > x_axis_size - 1 || x_coord < 0
        raise "Illegal X coordinate."
      end
      if y_coord > y_axis_size - 1 || y_coord < 0
        raise "Illegal Y coordinate."
      end
      if grid_array_2d[x_coord][y_coord] == nil
        raise "Variable error. Unknown variable #{variable} for cell (#{x_coord / 4}, #{y_coord / 2})"
      end
      variable_val = grid_array_2d[x_coord][y_coord].get_variable(variable)
      if variable_val == nil
        raise "Variable error. Unknown variable #{variable} for cell (#{x_coord / 4}, #{y_coord / 2})"
      end
      variable_val
    end
end