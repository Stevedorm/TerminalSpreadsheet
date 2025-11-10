require 'curses'
require_relative 'grid.rb'
require_relative 'lexer.rb'
require_relative 'parser.rb'
require_relative 'evaluate.rb'
require_relative 'runtime.rb'
require_relative 'vex_ast.rb'

include Curses

class Tui
    attr_accessor :s_win  # Window that encompasses the entire screen
    attr_accessor :g_win  # Grid window
    attr_accessor :f_win  # Formula window
    attr_accessor :f_win_big  # Big formula window
    attr_accessor :f_win_row
    attr_accessor :f_win_col
    attr_accessor :c_win  # Cell window
    attr_accessor :v_grid  # Vex grid
    attr_accessor :s_grid  # String grid (unevaluated forms)
    attr_accessor :screen_width  # Overall screen width
    attr_accessor :screen_height  # Overall screen height
    attr_accessor :g_win_height  # Height of graph window
    attr_accessor :g_win_width  # Width of graph window
    attr_accessor :vex_grid  # Grid to store stuff in
    attr_accessor :current_w  # Are we in the grid or in the formula window right now
    attr_accessor :g_win_row  # Grid window row (y-coordinate)
    attr_accessor :g_win_col  # Grid window column (x-coordinate)
    attr_accessor :runtime  # Runtime to use.
    attr_accessor :str_arr  # Un-evaluated string array to be used and re-evaluated.
    attr_accessor :str_arr_non_chopped  # Un-evaluated string array that hasn't been formatted at all
                                        # for display.

    def initialize()
        initialize_ui()
    end

    #Initialize screen.
    def initialize_ui()
        init_screen
        crmode
        noecho
        @screen_width = Curses.cols
        if @screen_width % 2 != 0
            @screen_width -= 1
        end
        @screen_height = Curses.lines
        if @screen_height % 2 != 0
            @screen_height -= 1
        end

        #Create windows. S = whole screen, F = function window, C = Cell window, G = grid window.
        @s_win = Window.new(@screen_height, @screen_width, 0, 0)
        @f_win = Window.new(1, @screen_width/2 - 1, 1, 1)
        @c_win = Window.new(1, @screen_width/2-2, 1, @screen_width/2+1)
        @g_win = Window.new(@screen_height-7,@screen_width-5, 5,4)
        @f_win_big = Window.new(@screen_height-3, @screen_width /2-1, 1, 1)
        @g_win_width = @screen_width - 5
        @g_win_height = @screen_height - 7

        #Draw grid lines
        setup_grid(@g_win, @g_win_width, @g_win_height)
        num_x_cells = (@g_win.maxx / 4 + 1)
        num_y_cells = (@g_win.maxy / 2 + 1)

        #Set up Vex grid
        @vex_grid = Grid.new(@g_win_width, @g_win_height)
        @runtime = Runtime.new(@vex_grid)
        @vex_grid.set_runtime(@runtime)

        #Set up unevaluated string array for use in evaluating.
        @str_arr = Array.new(@g_win_width)
        for i in (0..@str_arr.length)
          @str_arr[i] = Array.new(@g_win_height)
        end

        #Set up "non-chopped" string array for use in editing.
        @str_arr_non_chopped = Array.new(@g_win_width)
        for i in (0..@str_arr_non_chopped.length)
          @str_arr_non_chopped[i] = Array.new(@g_win_height)
        end
        @rev = 0
        grid_w_loop()
    end

    #General control/runtime loop
    def grid_w_loop()
        @g_win_row = 0
        @g_win_col = 0
        @g_win.keypad(true)
        @g_win.setpos(@g_win_row, @g_win_col)
        #Extra refreshes might be unecessary, we had some weird stuff so we threw them in willy-nilly
        loop do
            
            #Wrap cursor logic
            begin
                if @g_win_col > @g_win.maxx
                    @g_win_col = 0
                end
                if @g_win_row > @g_win.maxy
                    @g_win_row = 0
                end
                if @g_win_col < 0
                    @g_win_col = @g_win.maxx-3
                end
                if @g_win_row < 0
                    @g_win_col = @g_win.maxy - 1
                end
                @s_win.clear()
                @c_win.clear()
                @g_win.clear()
                @f_win.clear()
                @f_win_big.clear()
                update_cells()
                #Get user input. We hard-coded some of the key values, so it may not work if our code isn't run on stu through a powershell ssh session.
                draw_bounding()
                setup_grid(@g_win, @g_win_width, @g_win_height)
                draw_labels(@s_win, 4, 1, (@screen_height - 2), @screen_width - 2)
                @g_win.setpos(@g_win_row, @g_win_col)
                update_current_cell()
                @s_win.refresh()
                @f_win.refresh()
                @c_win.refresh()
                @g_win.refresh()
                user_input = @g_win.getch()
                if user_input == 27
                    break
                elsif user_input == 9  # Switch between grid and formula
                    @g_win.keypad(false)
                    @current_w = @f_win_big
                    should_continue = formula_w_loop(@g_win_row, @g_win_col)
                    if should_continue == -1
                        break
                    else
                        @g_win.keypad(true)
                        @current_w = @g_win
                        @g_win.setpos(@g_win_row, @g_win_col)
                        lexer = Lexer.new(should_continue)
                        parser = Parser.new(lexer.tokens)
                        parsed = parser.parse_top_level()
                        @str_arr[@g_win_col / 4][@g_win_row / 2] = should_continue
                    end
                elsif user_input == KEY_DOWN
                    @g_win_row += 2
                elsif user_input == KEY_UP
                    @g_win_row -= 2
                elsif user_input == KEY_LEFT
                    @g_win_col -=4
                elsif user_input == KEY_RIGHT
                    @g_win_col +=4
                end
            rescue => e
                @c_win.clear()
                @c_win.addstr("#{e.class}. #{e.message}")
                @c_win.refresh()
                @g_win.setpos(@g_win_row, @g_win_col)
            ensure
                if @g_win_row < 0
                    @g_win_row = @g_win.maxy - 1
                end
                if @g_win_col > @g_win.maxx
                    @g_win_col = 0
                end
                if @g_win_row > @g_win.maxy
                    @g_win_row = 0
                end
                if @g_win_col < 0
                    @g_win_col = @g_win.maxx - 3
                end
                
            end
        end
    end

    #Control loop for editing cells.
    def formula_w_loop(row, col)
        @f_win_big.keypad(true)
        @f_win_big.refresh()
        gathered_str = ""
        if @str_arr_non_chopped[@g_win_col / 4][@g_win_row / 2] != nil
            gathered_str = @str_arr_non_chopped[@g_win_col / 4][@g_win_row / 2]
        end
        loop do
            @f_win_big.setpos(0, 0)
            @f_win_big.clear()
            @f_win_big.addstr(gathered_str)
            if gathered_str.lines == nil
                @f_win_row = 0
            else
                @f_win_row = gathered_str.lines.count() - 1
            end
            if gathered_str.lines[-1] == nil
                @f_win_col = 0
            else
                @f_win_col = gathered_str.lines[-1].length()
            end
            @f_win_big.setpos(@f_win_row, @f_win_col)
            @f_win_big.refresh()
            user_input = @f_win.getch()
            case user_input.ord()

            when 92
                gathered_str = gathered_str ++ "\t"

            when 10  #Enter key
                gathered_str = gathered_str ++ "\n"

            when 9  # Tab key
                @f_win_big.keypad(false)
                @f_win_big.clear()
                to_int = Integer(gathered_str, exception: false)  # Attempt to convert gathered string to integer
                if to_int != nil
                    @str_arr_non_chopped[@g_win_col / 4][@g_win_row / 2] = gathered_str
                    return gathered_str
                end
                
                to_float = Float(gathered_str, exception: false)  # Attempt to convert gathered string to float
                if to_float != nil
                    @str_arr_non_chopped[@g_win_col / 4][@g_win_row / 2] = gathered_str
                    return gathered_str
                end

                if gathered_str.downcase == 'true'  # Attempt to convert gathered string to boolean
                    return gathered_str
                elsif gathered_str.downcase == 'false'
                    return gathered_str
                end

                if gathered_str.start_with?("=")  # See if gathered string is a function call.
                    @str_arr_non_chopped[@g_win_col / 4][@g_win_row / 2] = gathered_str
                    return gathered_str[1..-1]
                end

                if gathered_str.include?("Block")
                    @str_arr_non_chopped[@g_win_col / 4][@g_win_row / 2] = gathered_str
                    return gathered_str
                end

                if gathered_str.include?("if")  # If/else block
                    @str_arr_non_chopped[@g_win_col / 4][@g_win_row / 2] = gathered_str
                    return gathered_str
                end 

                @str_arr_non_chopped[@g_win_col / 4][@g_win_row / 2] = ( "\"" ++ gathered_str ++ "\"" )  # Last resort, return string.
                return ("\"" ++ gathered_str ++ "\"")

            when 127  # Backspace
                gathered_str = gathered_str[0...(gathered_str.length()-1)]

            when 27  # Escape key
                return -1

            else
                gathered_str = gathered_str + user_input.to_s()
            end
        end
    end

    #Evaluate every cell, from top left to bottom right.
    #NOTE: The way we do this introduces a small bug. Because we evaluate top left to bottom right.
    #if a cell (function, RValue, etc) is made in a cell to the left of the values it relies on,
    #and then one of the values it relies on is changed, the value in the function/whatever cell won't
    #update until the next cursor move/iteration in this loop. Small bug but worth mentioning.
    def update_cells()
        (0...@g_win_width).step(4).each do |col|
            (0...@g_win_height).step(2).each do |row|
                @g_win.setpos(row, col)
                cur_cell = @str_arr[col / 4][row / 2]
                if cur_cell != nil
                    begin
                        type = eval(cur_cell, col, row)
                        begin
                            @vex_grid.set_cell(col / 4, row / 2, type)
                            output = type.rawValue.to_s()
                            if output.length > 3
                                output = output[0..2]
                            end
                            @g_win.addstr(output)
                        
                        #Rescue for min/max/mean. These functions return cells, which are an issue for this evaluation,
                        #and needed to be handled specially.
                        rescue => cell_error
                            type = eval(cur_cell, col, row)
                            @vex_grid.set_cell(col / 4, row / 2, type.get_held_AST)
                            output = type.get_most_recent_primitive.rawValue.to_s
                            if output.length > 3
                                output = output[0..2]
                            end
                            @g_win.addstr(output)
                        end
                    rescue => nested_error
                        # Just display an error indicator in the cell
                        @c_win.addstr("#{nested_error.class}: #{nested_error.message}")
                    end
                end
            end
        end
    end

    #Modify current cell
    def update_current_cell()
        begin
            cur_cell = @vex_grid.get_cell(@g_win_col / 4, @g_win_row / 2)
            if cur_cell != nil
                string_rep = @str_arr[@g_win_col / 4][@g_win_row / 2]
                @f_win.clear()
                if string_rep.lines != nil && string_rep.lines.length > 0
                    @f_win.addstr(string_rep.lines[0])
                else
                    @f_win.addstr(string_rep)
                end
                type = eval(string_rep, @g_win_col / 4, @g_win_row / 2)
                begin
                    @vex_grid.set_cell(@g_win_col / 4, @g_win_row / 2, type)
                    output = type.rawValue.to_s()
                    @c_win.addstr(output)
                    if output.length > 3
                        output = output[0..2]
                    end
                    @g_win.attron(A_REVERSE)
                    @g_win.addstr(output)
                    @g_win.attroff(A_REVERSE)
                rescue
                    type = eval(string_rep, @g_win_col / 4, @g_win_row / 2)
                    @vex_grid.set_cell(@g_win_col / 4, @g_win_row / 2, type.get_held_AST)
                    output = type.get_most_recent_primitive.rawValue.to_s
                    @c_win.addstr(output)
                    if output.length > 3
                        output = output[0..2]
                    end
                    @g_win.attron(A_REVERSE)
                    @g_win.addstr(output)
                    @g_win.attroff(A_REVERSE)
                end
            else
                @g_win.attron(A_REVERSE)
                @g_win.addstr("   ")
                @g_win.attroff(A_REVERSE)
            end
        rescue => cell_access_error
            @c_win.addstr("#{cell_access_error.class}: #{cell_access_error.message}")
        end
    end

    #Draw the boundary of the window.
    def draw_bounding()
        horizontal_line(@s_win, 0, 1, @screen_width-1)
        horizontal_line(@s_win, @screen_height-2, 1, @screen_width-1)
        @s_win.setpos(0,0)
        @s_win.addstr("\u2554")
        @s_win.setpos(0,@screen_width-1)
        @s_win.addstr("\u2557")
        vertical_line(@s_win, 0, 1, @screen_height-1)
        vertical_line(@s_win, @screen_width-1, 1, @screen_height-1)
        @s_win.setpos(0, 1)
        @s_win.addstr("Formulas: ")
        horizontal_line(@s_win, 2, 1, @screen_width - 1)
        @s_win.setpos(@screen_height-2, 0)
        @s_win.addstr("\u255A")
        @s_win.setpos(@screen_height-2, @screen_width-1)
        @s_win.addstr("\u255D")
        @s_win.setpos(2, 0)
        @s_win.addstr("\u2560")
        @s_win.setpos(2, @screen_width-1)
        @s_win.addstr("\u2563")
        @s_win.setpos(0, @screen_width/2)
        @s_win.addstr("\u2566")
        @s_win.setpos(1, @screen_width/2)
        @s_win.addstr("\u2551")
        @s_win.setpos(2, @screen_width/2)
        @s_win.addstr("\u2569")
        @s_win.setpos(0, @screen_width/2 + 1)
        @s_win.addstr("Current Cell: ")
        @s_win.setpos(2, 1)
        @s_win.addstr("Grid:")
    end

    #Util method for evaluating cells.
    def eval (string, x_coord, y_coord)
        eval = Evaluate.new(@runtime)
        eval.x_coord = x_coord
        eval.y_coord = y_coord
        lexer = Lexer.new(string)
        parser = Parser.new(lexer.tokens)
        ast = parser.parse_top_level()
        value = eval.visit(ast)
        return value
    end


    # Util methods for drawing lines
    def horizontal_line(window, row, start_column, end_column)
        (start_column...end_column).each do |column|
            window.setpos(row, column)
            window.addstr("\u2550")
        end
    end
    
    def horizontal_line2(window, row, start_column, end_column)
        (start_column...end_column).each do |column|
            window.setpos(row, column)
            window.addstr("\u2500")
        end
    end
    
    def vertical_line(window, column, start_row, end_row)
        (start_row...end_row).each do |row|
            window.setpos(row, column)
            window.addstr("\u2551")
        end
    end
    
    def vertical_line2(window, column, start_row, end_row)
        (start_row...end_row).each do |row|
            window.setpos(row, column)
            window.addstr("\u2502")
        end
    end

    #Util method to draw labels on x and y-axis
    def draw_labels(bounding_box, top, left, bottom, right)
        vertical_label = 0
        print_vertical_label = 1
        horizontal_line2(bounding_box, top, left, right)
        (top+1...bottom).each do |row|
            bounding_box.setpos(row, left)
            if print_vertical_label == 1
                if (vertical_label < 10)
                    bounding_box.addstr((vertical_label.to_s) ++ " \u2502")
                else
                    bounding_box.addstr((vertical_label.to_s) ++ "\u2502")
                end
                vertical_label += 1
            end
            if print_vertical_label == 1
                print_vertical_label = 0
            else
                bounding_box.addstr("\u2500")
                bounding_box.setpos(row, left-1)
                bounding_box.addstr("\u255F")
                bounding_box.setpos(row, left+1)
                bounding_box.addstr("\u2500\u2502")
                print_vertical_label = 1
            end
        end
        horizontal_label = 0
        print_horizontal_label = 1
        (left+4...right).step(2).each do |col|
            bounding_box.setpos(top-1, col)
            if print_horizontal_label == 1
                if horizontal_label < 10
                    bounding_box.addstr((horizontal_label.to_s) ++ " \u2502")
                else
                    if (col == right - 1)
                        bounding_box.addstr(horizontal_label.to_s)
                    else
                        bounding_box.addstr((horizontal_label.to_s) ++ "\u2502")
                    end
                end
                horizontal_label += 1
            end
            if print_horizontal_label == 1
                print_horizontal_label = 0
            else
                print_horizontal_label = 1
            end
        end
        bounding_box.setpos(bottom, 3)
        bounding_box.addstr("\u2567")
        bounding_box.setpos(4, 3)
        bounding_box.addstr("\u252C")
        bounding_box.setpos(4, right)
        bounding_box.addstr("\u2500")
        bounding_box.setpos(4, right+1)
        bounding_box.addstr("\u2562")
    end

    #Util method for drawing lines on grid
    def setup_grid(grid_box, grid_box_width, grid_box_height)
        (3...grid_box_width).step(4).each do |col|
            vertical_line2(grid_box, col, 0, grid_box_height)
        end
        (1...grid_box_height).step(2).each do |row|
            horizontal_line2(grid_box, row, 0, grid_box_width)
        end
        (3...grid_box_width).step(4).each do |col|
            (1...grid_box_height).step(2).each do |row|
                grid_box.setpos(row, col)
                grid_box.addstr("\u253C")
            end
        end
    
    end

end