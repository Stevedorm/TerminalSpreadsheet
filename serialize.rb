class Serialize

  #Top-level recursive serialize call.
  def visit(node)
    node.visit(self)
  end

  #Visit an integer (just print raw value).
  def visit_integer(node)
    node.rawValue.to_s
  end

  #Visit a float (just print raw value).
  def visit_float(node)
    node.rawValue.to_s
  end

  #Visit a boolean (just print raw value).
  def visit_boolean(node)
    node.rawValue.to_s
  end

  #Visit a string (just print raw value).
  def visit_string(node)
    node.rawValue.to_s
  end

  #Visit a cell address: Format = {x coordinate}, {y coordinate}
  def visit_cellAddress(node)
    "#{node.rowVal.to_s}, #{node.colVal.to_s}"
  end

  #Visit addition: Format = value1 + value2
  def visit_add(node)
    "#{node.leftNode.visit(self)} + #{node.rightNode.visit(self)}"
  end

  #Visit subtraction: Format = value1 - value2
  def visit_subtract(node)
    "#{node.leftNode.visit(self)} - #{node.rightNode.visit(self)}"
  end

  #Visit multiplication: Format = value1 * value2
  def visit_multiply(node)
    "#{node.leftNode.visit(self)} * #{node.rightNode.visit(self)}"       
  end

  #Visit division: Format = value1 ÷ value2 
  def visit_divide(node)
    "#{node.leftNode.visit(self)} ÷ #{node.rightNode.visit(self)}"
  end

  #Visit modulo: Format = value1 % value2
  def visit_modulo(node)
    "#{node.leftNode.visit(self)} % #{node.rightNode.visit(self)}"
  end

  #Visit exponentiation: Format = value1 ^ value2
  def visit_exponentiation(node)
    "#{node.leftNode.visit(self)} ^ #{node.rightNode.visit(self)}"
  end

  #Visit negation: Format = -value
  def visit_negate(node)
    "-#{node.node.visit(self)}"
  end

  #Visit logical-and: Format = value1 && value2
  def visit_logicalAnd(node)
    "#{node.leftNode.visit(self)} && #{node.rightNode.visit(self)}"
  end

  #Visit logical-or: Format = value1 || value2
  def visit_logicalOr(node)
    "#{node.leftNode.visit(self)} || #{node.rightNode.visit(self)}"
  end

  #Visit logical-not: Format = !value
  def visit_logicalNot(node)
    "!#{node.node.visit(self)}"
  end

  #Visit cellLValue: Format = [x coordinate, y coordinate]
  def visit_cellLValue(node)
    "[#{node.leftNode.visit(self)}, #{node.rightNode.visit(self)}]"
  end

  #Visit cellRValue: Format = #[x coordinate, y coordinate]
  def visit_cellRValue(node)
    "#[#{node.leftNode.visit(self)}, #{node.rightNode.visit(self)}]"
  end

  #Visit bitwise and: Format = value1 & value2
  def visit_bitwiseAnd(node)
    "#{node.leftNode.visit(self)} & #{node.rightNode.visit(self)}"
  end

  #Visit bitwise or: Format = value1 | value2
  def visit_bitwiseOr(node)
    "#{node.leftNode.visit(self)} | #{node.rightNode.visit(self)}"
  end

  #Visit bitwise xor: Format = value1 ^ value2
  def visit_bitwiseXor(node)
    "#{node.leftNode.visit(self)} ^ #{node.rightNode.visit(self)}"
  end

  #Visit bitwise not: Format = ~value
  def visit_bitwiseNot(node)
    "~#{node.node.visit(self)}"
  end

  #Visit left shift: Format = value1 << value2
  def visit_leftShift(node)
    "#{node.leftNode.visit(self)} << #{node.rightNode.visit(self)}"
  end
  
  #Visit right shift: Format = value1 >> value2
  def visit_rightShift(node)
    "#{node.leftNode.visit(self)} >> #{node.rightNode.visit(self)}"
  end

  #Visit equal: Format = value1 == value2
  def visit_equal(node)
    "#{node.leftNode.visit(self)} == #{node.rightNode.visit(self)}"
  end

  #Visit not equal: Format = value1 != value2
  def visit_notEqual(node)
    "#{node.leftNode.visit(self)} != #{node.rightNode.visit(self)}"
  end

  #Visit less than: Format = value1 < value2
  def visit_lessThan(node)
    "#{node.leftNode.visit(self)} < #{node.rightNode.visit(self)}"
  end

  #Visit less than or equal to: Format = value1 <= value2
  def visit_lessOrEqualTo(node)
    "#{node.leftNode.visit(self)} <= #{node.rightNode.visit(self)}"
  end

  #Visit greater than: Format = value1 > value2
  def visit_greaterThan(node)
    "#{node.leftNode.visit(self)} > #{node.rightNode.visit(self)}"
  end

  #Visit greater than or equal to: Format = value1 >= value2
  def visit_greaterOrEqualTo(node)
    "#{node.leftNode.visit(self)} >= #{node.rightNode.visit(self)}"
  end

  #Visit float-to-int: Format = toInt(value)
  def visit_floatToInt(node)
    "toInt(#{node.node.visit(self)})"
  end

  #Visit int-to-float: Format = toFloat(value)
  def visit_intToFloat(node)
    "toFloat(#{node.node.visit(self)})"
  end

  #Visit min: Format = min([x coordinate 1, y coordinate 1], [x coordinate 2, y coordinate 2])
  def visit_min(node)
    "min([#{node.leftNode.visit(self)}], [#{node.rightNode.visit(self)}])"
  end

  #Visit max: Format = max([x coordinate 1, y coordinate 1], [x coordinate 2, y coordinate 2])
  def visit_max(node)
    "max([#{node.leftNode.visit(self)}], [#{node.rightNode.visit(self)}])"
  end

  #Visit mean: Format = mean([x coordinate 1, y coordinate 1], [x coordinate 2, y coordinate 2])
  def visit_mean(node)
    "mean([#{node.leftNode.visit(self)}], [#{node.rightNode.visit(self)}])"
  end
  
  #Visit sum: Format = sum([x coordinate 1, y coordinate 1], [x coordinate 2, y coordinate 2])
  def visit_sum(node)
    "sum([#{node.leftNode.visit(self)}], [#{node.rightNode.visit(self)}])"
  end

  #Visit a conditional: Format = if value1 conditional value2 {
  # then value
  #else
  # else value
  #}
  def visit_conditional(node)
    "if #{node.condition.visit(self)} \{\n    #{node.then_val.visit(self)}\nelse\n    #{node.else_val.visit(self)}\n\}"
  end

  #Visit variable (get value from variable): Format = 
  #variable_name
  def visit_variable(node)
    "#{node.name}"
  end

  #Visit for-each: Format = 
  #for variable_name in [x_coord1, y_coord1]../...[x_coord2, y_coord2]
  def visit_for_each(node)
    result = "for #{node.iter.visit(self)} in #{node.startAddress.visit(self)}"
    if node.rangeOp == "inclusive_range"
      result << ".."
    elsif node.rangeOp == "exclusive_range"
      result << "..."
    end
    result << "#{node.endAddress.visit(self)} \{\n#{node.block.visit(self)}\n\}"
    result
  end

  #Visit assignment: Format = variable_name = variable_value
  def visit_assignment(node)
    "#{node.name} = #{node.val.visit(self)}"
  end

  #Visit each statement in a block.
  def visit_block(node)
    result = ""
    for value in node.statements
      result << "#{value.visit(self)}\n"
    end
    result
  end
end