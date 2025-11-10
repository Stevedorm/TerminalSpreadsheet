require_relative 'vex_ast.rb'
require_relative 'runtime.rb'

class Evaluate
  attr_reader :runtime
  attr_reader :grid
  attr_accessor :x_coord
  attr_accessor :y_coord

  #Initialize the evaluator. Needs a runtime.
  def initialize(runtime)
    @runtime = runtime
  end

  #Visit the node, which makes a recursive call to the node's visit.
  def visit(node)
    node.visit(self)
  end

  #Visit integer node. Just returns the node.
  def visit_integer(node)
    node
  end

  #Visit float node. Just returns the node.
  def visit_float(node)
    node
  end

  #Visit boolean node. Just returns the node.
  def visit_boolean(node)
    node
  end

  #Visit string node. Just returns the node.
  def visit_string(node)
    node
  end

  #Visit cell address. Just returns the node.
  def visit_cellAddress(node)
    node
  end

  

  #Evaluate an addition.
  def visit_add(node)
    left_val = node.leftNode.visit(self)
    right_val = node.rightNode.visit(self)
    left_valid = false
    right_valid = false
    return_val = nil
    if left_val.class == VexAST::Integer || left_val.class == VexAST::Float
      left_valid = true
    end
    if right_val.class == VexAST::Integer || right_val.class == VexAST::Float
      right_valid = true
    end
    if left_valid && right_valid
      new_val = left_val.rawValue + right_val.rawValue
      if new_val.is_a?(Float)
        return_val = VexAST::Float.new(new_val)
      else
        return_val = VexAST::Integer.new(new_val)
      end
    else
      raise "Addition Exception: Invalid types of operands for addition"
    end
    return_val
  end

  #Evaluate a subtraction.
  def visit_subtract(node)
    left_val = node.leftNode.visit(self)
    right_val = node.rightNode.visit(self)
    left_valid = false
    right_valid = false
    return_val = nil
    if left_val.class == VexAST::Integer || left_val.class == VexAST::Float
      left_valid = true
    end
    if right_val.class == VexAST::Integer || right_val.class == VexAST::Float
      right_valid = true
    end
    if left_valid && right_valid
      new_val = left_val.rawValue - right_val.rawValue
      if new_val.is_a?(Float)
        return_val = VexAST::Float.new(new_val)
      else
        return_val = VexAST::Integer.new(new_val)
      end
    else
      raise "Subtraction Exception: Invalid types of operands for subtraction"
    end
    return_val
  end

  #Evaluate a multiply.
  def visit_multiply(node)
    left_val = node.leftNode.visit(self)
    right_val = node.rightNode.visit(self)
    left_valid = false
    right_valid = false
    return_val = nil
    if left_val.class == VexAST::Integer || left_val.class == VexAST::Float
      left_valid = true
    end
    if right_val.class == VexAST::Integer || right_val.class == VexAST::Float
      right_valid = true
    end
    if left_valid && right_valid
      new_val = left_val.rawValue * right_val.rawValue
      if new_val.is_a?(Float)
        return_val = VexAST::Float.new(new_val)
      else
        return_val = VexAST::Integer.new(new_val)
      end
    else
      raise "Multiplication Exception: Invalid types of operands for multiplication"
    end
    return_val
  end

  #Evaluate a divide.
  def visit_divide(node)
    left_val = node.leftNode.visit(self)
    right_val = node.rightNode.visit(self)
    left_valid = false
    right_valid = false
    return_val = nil
    if left_val.class == VexAST::Integer || left_val.class == VexAST::Float
      left_valid = true
    end
    if right_val.class == VexAST::Integer || right_val.class == VexAST::Float
      right_valid = true
    end
    if left_valid && right_valid
      new_val = left_val.rawValue / right_val.rawValue
      if new_val.is_a?(Float)
        return_val = VexAST::Float.new(new_val)
      else
        return_val = VexAST::Integer.new(new_val)
      end
    else
      raise "Division Exception: Invalid types of operands for division"
    end
    return_val
  end

  #Evaluate a modulo.
  def visit_modulo(node)
    left_val = node.leftNode.visit(self)
    right_val = node.rightNode.visit(self)
    left_valid = false
    right_valid = false
    return_val = nil
    if left_val.class == VexAST::Integer || left_val.class == VexAST::Float
      left_valid = true
    end
    if right_val.class == VexAST::Integer || right_val.class == VexAST::Float
      right_valid = true
    end
    if left_valid && right_valid
      new_val = left_val.rawValue % right_val.rawValue
      return_val = VexAST::Integer.new(new_val)
    else
      raise "Modulus Exception: Invalid types of operands for modulo"
    end
    return_val
  end

  #Visit an exponentiation.
  def visit_exponentiation(node)
    left_val = node.leftNode.visit(self)
    right_val = node.rightNode.visit(self)
    left_valid = false
    right_valid = false
    return_val = nil
    if left_val.class == VexAST::Integer || left_val.class == VexAST::Float
      left_valid = true
    end
    if right_val.class == VexAST::Integer || right_val.class == VexAST::Float
      right_valid = true
    end
    if left_valid && right_valid
      new_val = left_val.rawValue ** right_val.rawValue
      if new_val.is_a?(Float)
        return_val = VexAST::Float.new(new_val)
      else
        return_val = VexAST::Integer.new(new_val)
      end
    else
      raise "Exponentiation Exception: Invalid types of operands for exponentiation"
    end
    return_val
  end

  #Visit a negation.
  def visit_negate(node)
    value = node.node.visit(self)
    node_valid = false
    return_val = nil
    if value.class == VexAST::Integer || value.class == VexAST::Float
      node_valid = true
    end
    if node_valid
      new_val = -1 * value.rawValue
      if new_val.is_a?(Float)
        return_val = VexAST::Float.new(new_val)
      else
        return_val = VexAST::Integer.new(new_val)
      end
    else
      raise "Negation Exception: Invalid type of operand for negation"
    end
    return_val
  end

  #Visit a logical and.
  def visit_logicalAnd(node)
    left_val = node.leftNode.visit(self)
    right_val = node.rightNode.visit(self)
    left_valid = false
    right_valid = false
    new_val = nil
    return_val = nil
    if left_val.class == VexAST::Boolean
      left_valid = true
    end
    if right_val.class == VexAST::Boolean
      right_valid = true
    end
    if left_valid && right_valid
      new_val = left_val.rawValue && right_val.rawValue
      return_val = VexAST::Boolean.new(new_val)
    else
      raise "Logical And Exception: Invalid operand types for logical and"
    end
  end

  #Visit a logical or.
  def visit_logicalOr(node)
    left_val = node.leftNode.visit(self)
    right_val = node.rightNode.visit(self)
    left_valid = false
    right_valid = false
    new_val = nil
    return_val = nil
    if left_val.class == VexAST::Boolean
      left_valid = true
    end
    if right_val.class == VexAST::Boolean
      right_valid = true
    end
    if left_valid && right_valid
      new_val = left_val.rawValue || right_val.rawValue
      return_val = VexAST::Boolean.new(new_val)
    else
      raise "Logical Or Exception: Invalid operand types for logical or"
    end
  end

  #Visit a logical not.
  def visit_logicalNot(node)
    node_val = node.node.visit(self)
    node_valid = false
    new_val = nil
    return_val = nil
    if node_val.class == VexAST::Boolean
      node_valid = true
    end
    if node_valid
      new_val = !node_val.rawValue
      return_val = VexAST::Boolean.new(new_val)
    else
      raise "Logical Not Exception: Invalid operand type for logical not"
    end
  end

  #Visit a bitwise and.
  def visit_bitwiseAnd(node)
    left_val = node.leftNode.visit(self)
    right_val = node.rightNode.visit(self)
    left_valid = false
    right_valid = false
    new_val = nil
    return_val = nil
    if right_val.class == VexAST::Float || left_val.class == VexAST::Float
      raise "Number cannot be float"
    end
    if left_val.class == VexAST::Integer
      left_valid = true
    end
    if right_val.class == VexAST::Integer
      right_valid = true
    end
    if left_valid && right_valid
      new_val = left_val.rawValue & right_val.rawValue
      if new_val.is_a?(Float)
        return_val = VexAST::Float.new(new_val)
      else
        return_val = VexAST::Integer.new(new_val)
      end
    else
      raise "Bitwise And Exception: Invalid operand types for bitwise and"
    end
    return_val
  end

  #Visit a bitwise or.
  def visit_bitwiseOr(node)
    left_val = node.leftNode.visit(self)
    right_val = node.rightNode.visit(self)
    left_valid = false
    right_valid = false
    new_val = nil
    return_val = nil
    if right_val.class == VexAST::Float || left_val.class == VexAST::Float
      raise "Number cannot be float"
    end
    if left_val.class == VexAST::Integer
      left_valid = true
    end
    if right_val.class == VexAST::Integer
      right_valid = true
    end
    if left_valid && right_valid
      new_val = left_val.rawValue | right_val.rawValue
      if new_val.is_a?(Float)
        return_val = VexAST::Float.new(new_val)
      else
        return_val = VexAST::Integer.new(new_val)
      end
    else
      raise "Bitwise Or Exception: Invalid operand types for bitwise or"
    end
    return_val
  end

  #Visit a bitwise xor.
  def visit_bitwiseXor(node)
    left_val = node.leftNode.visit(self)
    right_val = node.rightNode.visit(self)
    left_valid = false
    right_valid = false
    new_val = nil
    return_val = nil
    if right_val.class == VexAST::Float || left_val.class == VexAST::Float
      raise "Number cannot be float"
    end
    if left_val.class == VexAST::Integer
      left_valid = true
    end
    if right_val.class == VexAST::Integer
      right_valid = true
    end
    if left_valid && right_valid
      new_val = left_val.rawValue ^ right_val.rawValue
      if new_val.is_a?(Float)
        return_val = VexAST::Float.new(new_val)
      else
        return_val = VexAST::Integer.new(new_val)
      end
    else
      raise "Bitwise Xor Exception: Invalid operand types for bitwise xor"
    end
    return_val
  end

  #Visit a bitwise not
  def visit_bitwiseNot(node)
    val = node.node.visit(self)
    val_valid = false
    new_val = nil
    return_val = nil
    if val.class == VexAST::Float
      raise "Number cannot be float"
    end
    if val.class == VexAST::Integer
      val_valid = true
    end
    if val_valid
      new_val = ~val.rawValue
      if new_val.is_a?(Float)
        return_val = VexAST::Float.new(new_val)
      else
        return_val = VexAST::Integer.new(new_val)
      end
    else
      raise "Bitwise Not Exception: Invalid operand types for bitwise not"
    end
    return_val
  end

  #Visit a left shift.
  def visit_leftShift(node)
    left_val = node.leftNode.visit(self)
    right_val = node.rightNode.visit(self)
    left_valid = false
    right_valid = false
    new_val = nil
    return_val = nil
    if right_val.class == VexAST::Float || left_val.class == VexAST::Float
      raise "Number cannot be float"
    end
    if left_val.class == VexAST::Integer
      left_valid = true
    end
    if right_val.class == VexAST::Integer
      right_valid = true
    end
    if left_valid && right_valid
      new_val = left_val.rawValue << right_val.rawValue
      if new_val.is_a?(Float)
        return_val = VexAST::Float.new(new_val)
      else
        return_val = VexAST::Integer.new(new_val)
      end
    else
      raise "Left Shift Exception: Invalid operand types for left shift"
    end
    return_val
  end

  #Visit a right shift.
  def visit_rightShift(node)
    left_val = node.leftNode.visit(self)
    right_val = node.rightNode.visit(self)
    left_valid = false
    right_valid = false
    new_val = nil
    return_val = nil
    if right_val.class == VexAST::Float || left_val.class == VexAST::Float
      raise "Number cannot be float"
    end
    if left_val.class == VexAST::Integer
      left_valid = true
    end
    if right_val.class == VexAST::Integer
      right_valid = true
    end
    if left_valid && right_valid
      new_val = left_val.rawValue >> right_val.rawValue
      if new_val.is_a?(Float)
        return_val = VexAST::Float.new(new_val)
      else
        return_val = VexAST::Integer.new(new_val)
      end
    else
      raise "Right Shift Exception: Invalid operand types for right shift"
    end
    return_val
  end

  #Visit an equal.
  def visit_equal(node)
    left_val = node.leftNode.visit(self)
    right_val = node.rightNode.visit(self)
    left_valid = false
    right_valid = false
    new_val = nil
    return_val = nil
    if left_val.class == VexAST::Integer || left_val.class == VexAST::Float
      left_valid = true
    end
    if right_val.class == VexAST::Integer || right_val.class == VexAST::Float
      right_valid = true
    end
    if left_valid && right_valid
      new_val = left_val.rawValue == right_val.rawValue
      return_val = VexAST::Boolean.new(new_val)
    else
      raise "Equals Exception: Invalid operand types for equals"
    end
  end

  #Visit a not equal.
  def visit_notEqual(node)
    left_val = node.leftNode.visit(self)
    right_val = node.rightNode.visit(self)
    left_valid = false
    right_valid = false
    new_val = nil
    return_val = nil
    if left_val.class == VexAST::Integer || left_val.class == VexAST::Float
      left_valid = true
    end
    if right_val.class == VexAST::Integer || right_val.class == VexAST::Float
      right_valid = true
    end
    if left_valid && right_valid
      new_val = left_val.rawValue != right_val.rawValue
      return_val = VexAST::Boolean.new(new_val)
    else
      raise "Not Equal Exception: Invalid operand types for not equal"
    end
  end
  
  #Visit a greater than.
  def visit_greaterThan(node)
    left_val = node.leftNode.visit(self)
    right_val = node.rightNode.visit(self)
    left_valid = false
    right_valid = false
    new_val = nil
    return_val = nil
    if left_val.class == VexAST::Integer || left_val.class == VexAST::Float
      left_valid = true
    end
    if right_val.class == VexAST::Integer || right_val.class == VexAST::Float
      right_valid = true
    end
    if left_valid && right_valid
      new_val = left_val.rawValue > right_val.rawValue
      return_val = VexAST::Boolean.new(new_val)
    else
      raise "Greater Than Exception: Invalid operand types for greater than"
    end
  end

  #Visit a greater than or equal to.
  def visit_greaterOrEqualTo(node)
    left_val = node.leftNode.visit(self)
    right_val = node.rightNode.visit(self)
    left_valid = false
    right_valid = false
    new_val = nil
    return_val = nil
    if left_val.class == VexAST::Integer || left_val.class == VexAST::Float
      left_valid = true
    end
    if right_val.class == VexAST::Integer || right_val.class == VexAST::Float
      right_valid = true
    end
    if left_valid && right_valid
      new_val = left_val.rawValue >= right_val.rawValue
      return_val = VexAST::Boolean.new(new_val)
    else
      raise "Greater Than Or Equal Exception: Invalid operand types for Greater Than Or Equal"
    end
  end

  #Visit a less than or equal to.
  def visit_lessOrEqualTo(node)
    left_val = node.leftNode.visit(self)
    right_val = node.rightNode.visit(self)
    left_valid = false
    right_valid = false
    new_val = nil
    return_val = nil
    if left_val.class == VexAST::Integer || left_val.class == VexAST::Float
      left_valid = true
    end
    if right_val.class == VexAST::Integer || right_val.class == VexAST::Float
      right_valid = true
    end
    if left_valid && right_valid
      new_val = left_val.rawValue <= right_val.rawValue
      return_val = VexAST::Boolean.new(new_val)
    else
      raise "Less Than Or Equal Exception: Invalid operand types for Less Than Or Equal"
    end
  end

  #Visit a less than.
  def visit_lessThan(node)
    left_val = node.leftNode.visit(self)
    right_val = node.rightNode.visit(self)
    left_valid = false
    right_valid = false
    new_val = nil
    return_val = nil
    if left_val.class == VexAST::Integer || left_val.class == VexAST::Float
      left_valid = true
    end
    if right_val.class == VexAST::Integer || right_val.class == VexAST::Float
      right_valid = true
    end
    if left_valid && right_valid
      new_val = left_val.rawValue < right_val.rawValue
      return_val = VexAST::Boolean.new(new_val)
    else
      raise "Less Than Exception: Invalid operand types for Less Than"
    end
  end

  #Visit a sum.
  def visit_sum(node)
    left_val = node.leftNode.visit(self)
    right_val = node.rightNode.visit(self)
    left_valid = false
    right_valid = false
    if left_val.class == VexAST::CellAddress
      left_valid = true
    end
    if right_val.class == VexAST::CellAddress
      right_valid = true
    end
    if left_valid && right_valid
      sum = 0
      for x_val in (left_val.rowVal..right_val.rowVal)
        for y_val in (left_val.colVal..right_val.colVal)
          current_cell = runtime.get_grid.get_cell(x_val, y_val)
          if current_cell != nil && (current_cell.get_most_recent_primitive.class == VexAST::Integer || current_cell.get_most_recent_primitive.class == VexAST::Float)
            sum = sum + current_cell.get_most_recent_primitive.rawValue
          elsif current_cell == nil
            #Skip nil values
          else
            raise "Sum Exception: Invalid cell type at [#{x_val}, #{y_val}]"
          end
        end
      end
      if sum.class.is_a?(Float)
        return_val = VexAST::Float.new(sum)
      else
        return_val = VexAST::Integer.new(sum)
      end
    else
      raise "Sum Exception: Invalid cell coordinates"
    end
  end

  #Visit a minimum.
  def visit_min(node)
    left_val = node.leftNode.visit(self)
    right_val = node.rightNode.visit(self)
    left_valid = false
    right_valid = false
    if left_val.class == VexAST::CellAddress
      left_valid = true
    end
    if right_val.class == VexAST::CellAddress
      right_valid = true
    end
    if left_valid && right_valid
      min = Float::INFINITY
      min_cell = nil
      for x_val in (left_val.rowVal..right_val.rowVal)
        for y_val in (left_val.colVal..right_val.colVal)
          current_cell = runtime.get_grid.get_cell(x_val, y_val)
          if current_cell != nil && (current_cell.get_most_recent_primitive.class == VexAST::Integer || current_cell.get_most_recent_primitive.class == VexAST::Float)
            if current_cell.get_most_recent_primitive.rawValue < min
              min = current_cell.get_most_recent_primitive.rawValue
              min_cell = current_cell
            end
          elsif current_cell == nil
            #Skip nil values
          else
            raise "Min Exception: Invalid cell type at [#{x_val}, #{y_val}]"
          end
        end
      end
      min_cell
    else
      raise "Min Exception: Invalid cell coordinates"
    end
  end

  #Visit a maximum.
  def visit_max(node)
    left_val = node.leftNode.visit(self)
    right_val = node.rightNode.visit(self)
    left_valid = false
    right_valid = false
    if left_val.class == VexAST::CellAddress
      left_valid = true
    end
    if right_val.class == VexAST::CellAddress
      right_valid = true
    end
    if left_valid && right_valid
      max = -1.0/0.0
      max_cell = nil
      for x_val in (left_val.rowVal..right_val.rowVal)
        for y_val in (left_val.colVal..right_val.colVal)
          current_cell = runtime.get_grid.get_cell(x_val, y_val)
          if current_cell != nil && (current_cell.get_most_recent_primitive.class == VexAST::Integer || current_cell.get_most_recent_primitive.class == VexAST::Float)
            if current_cell.get_most_recent_primitive.rawValue > max
              max = current_cell.get_most_recent_primitive.rawValue
              max_cell = current_cell
            end
          elsif current_cell == nil
            #Skip nil values
          else
            raise "Max Exception: Invalid cell type at [#{x_val}, #{y_val}]"
          end
        end
      end
      max_cell
    else
      raise "Max Exception: Invalid cell coordinates"
    end
  end

  #Visit a mean.
  def visit_mean(node)
    left_val = node.leftNode.visit(self)
    right_val = node.rightNode.visit(self)
    left_valid = false
    right_valid = false
    if left_val.class == VexAST::CellAddress
      left_valid = true
    end
    if right_val.class == VexAST::CellAddress
      right_valid = true
    end
    if left_valid && right_valid
      summed_vals = 0
      num_vals = 0
      for x_val in (left_val.rowVal..right_val.rowVal)
        for y_val in (left_val.colVal..right_val.colVal)
          current_cell = runtime.get_grid.get_cell(x_val, y_val)
          if current_cell != nil && (current_cell.get_most_recent_primitive.class == VexAST::Integer || current_cell.get_most_recent_primitive.class == VexAST::Float)
            summed_vals += current_cell.get_most_recent_primitive.rawValue
            num_vals += 1
          elsif current_cell == nil
            #Skip nil values
          else
            raise "Mean Exception: Invalid cell type at [#{x_val}, #{y_val}]"
          end
        end
      end
      mean_val = summed_vals / num_vals
      if mean_val.is_a?(Float)
        return_val = VexAST::Float.new(mean_val)
      else
        return_val = VexAST::Integer.new(mean_val)
      end
    else
      raise "Mean Exception: Invalid cell coordinates"
    end
  end

  #Visit a float-to-int conversion.
  def visit_floatToInt(node)
    value = node.node.visit(self)
    node_valid = false
    new_val = nil
    return_val = nil
    if value.class == VexAST::Float
      node_valid = true
    end
    if node_valid
      new_val =  value.rawValue.round() # to_i?
      return_val = VexAST::Integer.new(new_val)
    else
      raise "FloatToInt Exception: Invalid type of operand for FloatToInt"
    end
    return_val
  end

  #Visit an int-to-float conversion.
  def visit_intToFloat(node)
    value = node.node.visit(self)
    node_valid = false
    new_val = nil
    return_val = nil
    if value.class == VexAST::Integer
      node_valid = true
    end
    if node_valid
      new_val =  value.rawValue.to_f
      return_val = VexAST::Float.new(new_val)
    else
      raise "IntToFloat Exception: Invalid type of operand for IntToFloat"
    end
    return_val
  end

  #Visit a cell-l-value (Cell Address).
  def visit_cellLValue(node)
    left_val = node.leftNode.visit(self)
    right_val = node.rightNode.visit(self)
    return_val = nil
    left_valid = false
    right_valid = false
    if left_val.is_a?(VexAST::Integer) && left_val.rawValue.is_a?(Integer) && left_val.rawValue >= 0
      left_valid = true
    end
    if right_val.is_a?(VexAST::Integer) && right_val.rawValue.is_a?(Integer) && right_val.rawValue >= 0
      right_valid = true
    end
    if left_valid && right_valid
      return_val = VexAST::CellAddress.new(left_val.rawValue, right_val.rawValue)
    else
      raise "CellLValue Exception: Invalid operand types for CellLValue"
    end
  end

  #Visit a cell-r-value (Value from cell).
  def visit_cellRValue(node)
    left_val = node.leftNode.visit(self)
    right_val = node.rightNode.visit(self)
    return_val = nil
    left_valid = false
    right_valid = false
    if left_val.is_a?(VexAST::Integer) && left_val.rawValue >= 0
      left_valid = true
    end
    if right_val.is_a?(VexAST::Integer) && right_val.rawValue >= 0
      right_valid = true
    end
    if left_valid && right_valid
      return_val = runtime.get_grid.get_cell(left_val.rawValue, right_val.rawValue).get_most_recent_primitive
    else
      raise "CellRValue Exception: Invalid operand types for CellRValue"
    end
  end

  #Visit a conditional.
  def visit_conditional(node)
    result = node.condition.visit(self)
    return_val = nil
    if result.rawValue == true  # If
      return_val = node.then_val.visit(self)
    else
      return_val = node.else_val.visit(self)
    end
  end

  #Visit a variable (get value from variable.)
  def visit_variable(node)
    variable_val = runtime.get_grid.get_cell_variable(@x_coord, @y_coord, node.name)
    if variable_val == nil
      raise "Variable exception. Undefined variable #{node.name} for cell [#{@x_coord / 4}, #{@y_coord / 2}]"
    end
    return_val = variable_val.visit(self)
  end

  #Visit an assignment (assign a value to a variable)
  def visit_assignment(node)
    assignment_value = node.val.visit(self)
    runtime.get_grid.add_cell_variable(@x_coord, @y_coord, node.name, assignment_value)
  end

  #Visit a for-each.
  def visit_for_each(node)
    variable = node.iter
    start = node.startAddress
    endI = node.endAddress
    result = nil
    puts node.rangeOp
    if node.rangeOp == ".."
      for x in start.leftNode.rawValue..endI.leftNode.rawValue
        for y in start.rightNode.rawValue..endI.rightNode.rawValue
          current_cell = runtime.get_grid.get_cell(x, y)
          puts current_cell.get_most_recent_primitive.rawValue
          if current_cell != nil
            runtime.get_grid.add_cell_variable(@x_coord, @y_coord, variable, current_cell.get_most_recent_primitive)
            result = node.block.visit(self) # should it be indexes of runtime passed then visited?
          end
        end
      end
    elsif node.rangeOp == "..."
      for x in start.leftNode.rawValue...endI.leftNode.rawValue
        for y in start.rightNode.rawValue...endI.rightNode.rawValue
          current_cell = runtime.get_grid.get_cell(x, y)
          if current_cell != nil
            runtime.get_grid.add_cell_variable(@x_coord, @y_coord, variable, current_cell.get_most_recent_primitive)
            result = node.block.visit(self) # should it be indexes of runtime passed then visited?
          end
        end
      end
    end
    result
  end

  #Visit a block (just evaluate every statement and return the last one).
  def visit_block(node)
    last = nil
    for val in node.statements
      last = val.visit(self)
    end
    last
  end
end