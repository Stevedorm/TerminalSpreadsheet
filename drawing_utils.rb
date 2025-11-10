require 'curses'

include Curses

#Draw the outer bounding box around the spreadsheet.
def draw_bounds(window, height, width)
  horizontal_line(window, 0, 1, width-1)
  horizontal_line(window, height-2, 1, width-1)
  window.setpos(0,0)
  window.addstr("\u2554")
  window.setpos(0,width-1)
  window.addstr("\u2557")
  vertical_line(window, 0, 1, height-1)
  vertical_line(window, width-1, 1, height-1)
  window.setpos(height-2, 0)
  window.addstr("\u255A")
  window.setpos(height-2, width-1)
  window.addstr("\u255D")
end

#Draw a horizontal line with a thick line.
def horizontal_line(window, row, start_column, end_column)
  (start_column...end_column).each do |column|
      window.setpos(row, column)
      window.addstr("\u2550")
  end
end

#Draw a horizontal line with a skinny line.
def horizontal_line2(window, row, start_column, end_column)
  (start_column...end_column).each do |column|
      window.setpos(row, column)
      window.addstr("\u2500")
  end
end

#Draw a vertical line with a thick line.
def vertical_line(window, column, start_row, end_row)
  (start_row...end_row).each do |row|
      window.setpos(row, column)
      window.addstr("\u2551")
  end
end

#Draw a vertical line with a skinny line.
def vertical_line2(window, column, start_row, end_row)
  (start_row...end_row).each do |row|
      window.setpos(row, column)
      window.addstr("\u2502")
  end
end

#Draw the grid for the spreadsheet.
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

#Draw the labels around the grid.
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
  (left+5...right-10).step(2).each do |col|
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