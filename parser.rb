require_relative 'lexer.rb'
require_relative 'vex_ast.rb'

class Parser
  attr_accessor :tokens
  attr_accessor :index
  attr_accessor :statements
  attr_accessor :x_coord
  attr_accessor :y_coord

  #Initialize the parser with the tokens we get from our lexer.
  def initialize(tokens)
    @tokens = tokens
    @index = 0
    @statements = Array.new
  end

  #Advance to the next token.
  def advance()
    token = @tokens[@index]
    @index = @index + 1
    return token
  end
  
  #Check if the next token is of a type.
  def has(type)
    @index < @tokens.length && @tokens[@index].type.to_s == type 
  end

  #Top-level parse function called at the beginning.
  def parse_top_level()
    result = parse()
    if @index < @tokens.length
      raise "Parse Error: Unexpected token #{@tokens[@index].text} at position #{@tokens[@index].start_pos}"
    end
    return result
  end

  #Top-level parse function called while mid-input.
  def parse() #top-level
    level6()
  end

  #Parse a block statement
  def level6() #Blocks
    if has("block")
      advance()
      statements = Array.new
      while has("newline")
        advance()
        current_statement = level6()
        statements.push(current_statement)
      end
      return VexAST::Block.new(statements)
    else
      level7()
    end
  end

  #Parse an assignment 
  def level7()
    if has("variable")
      @index += 1
      if has("assignment_operator")
        @index -= 1
        reference_name = advance().text
        advance()  # Go past =
        reference_val = level7()
        return VexAST::Assignment.new(reference_name, reference_val)
      else
        @index -= 1
        level8()
      end
    else
      level8()
    end
  end
    
  #Parse a logical-and/or.
  def level8() # && / || (Logical and/or)
    left = level9()
    while has("logical_and") || has("logical_or")
      op = advance().type.to_s
      right = level9()
      left = case op
              when "logical_and" then VexAST::LogicalAnd.new(left, right)
              when "logical_or" then VexAST::LogicalOr.new(left, right)
              end
    end
    return left
  end

  #Parse comparison.
  def level9() # == != < <= > >= (Less/less-equal/greater/greater-equal/equal/not-equal)
    left = level10()
    while has("equal_to") || has("not_equal") || has("less_than") || has("greater_than") || has("less_equal") || has("greater_equal")
      op = advance().type.to_s
      right = level10()
      left = case op
              when "equal_to" then VexAST::Equal.new(left, right)
              when "not_equal" then VexAST::NotEqual.new(left, right)
              when "less_than" then VexAST::LessThan.new(left, right)
              when "greater_than" then VexAST::GreaterThan.new(left, right)
              when "less_equal" then VexAST::LessOrEqualTo.new(left, right)
              when "greater_equal" then VexAST::GreaterOrEqualTo.new(left, right)
              end
    end
    return left
  end

  #Parse bitwise operation.
  def level10() # & | ^ (Bitwise and/or/xor)
    left = level11()
    while has("bitwise_and") || has("bitwise_or") || has("bitwise_xor")
      if has("bitwise_and")
        advance()
        right = level11()
        left = VexAST::BitwiseAnd.new(left, right)
      elsif has("bitwise_or")
        advance()
        right = level11()
        left = VexAST::BitwiseOr.new(left, right)
      else
        advance()
        right = level11()
        left = VexAST::BitwiseXor.new(left, right)
      end
    end
    return left
  end

  #Parse left-shift and right-shift.
  def level11() # << >> (Lshift/rshift)
    left = level12()
    while has("lshift") || has("rshift")
      if has("lshift")
        advance()
        right = level12()
        left = VexAST::LeftShift.new(left, right)
      else
        advance()
        right = level12()
        left = VexAST::RightShift.new(left, right)
      end
    end
    return left
  end

  #Parse addition/subtraction.
  def level12() # + - (Addition and subtraction)
    left = level13()
    while has("plus") || has("minus")
      if has("plus")
        advance()
        right = level13()
        left = VexAST::Add.new(left, right)
      else
        advance()
        right = level13()
        left = VexAST::Subtract.new(left, right)
      end
    end
    return left
  end

  #Parse multiply/divide/modulo.
  def level13() # * / % (Multiply, divide, mod)
    left = level14()
    while has("multiply") || has("slash") || has("percent")
      if has("multiply")
        advance()
        right = level14()
        left = VexAST::Multiply.new(left, right)
      elsif has("slash")
        advance()
        right = level14()
        left = VexAST::Divide.new(left, right)
      else
        advance()
        right = level14()
        left = VexAST::Modulo.new(left, right)
      end
    end
    return left
  end

  #Parse bitwise-not.
  def level14() # ~ (Bitwise not)
    left = nil
    if has("bitwise_not")
        advance()
        right = level15()
        left = VexAST::BitwiseNot.new(right)
    else
      left = level15()
    end
    return left
  end

  #Parse exponentiation (**).
  def level15() # ** (Exponentiation)
    left = level16()
    if has("exponent")
      advance()
      right = level15()
      node = VexAST::Exponentiation.new(left, right)
      return node
    else
      return left
    end
  end

  #Parse a negation.
  def level16() # Negation
    if has("minus")
      advance()
      node = VexAST::Negate.new(level16())
    else
      node = level17()
    end
    return node
  end

  #Parse a logical not.
  def level17() # ! (Logical Not)
    if has("logical_not")
      advance()
      node = VexAST::LogicalNot.new(level17())
    else
      node = levelN()
    end
    return node
  end

  #Bottom-level parse level.
  def levelN()
    if has("int") # Integer
      node = VexAST::Integer.new(advance().text.to_i)
      return node
    elsif has("float") # Float
      node = VexAST::Float.new(advance().text.to_f)
      return node
    elsif has("string") # String
      node = VexAST::String.new(advance.text)
      return node
    elsif has("true") # True
      advance()
      node = VexAST::Boolean.new(true)
      return node
    elsif has("false") # False
      advance()
      node = VexAST::Boolean.new(false)
      return node
    elsif has("left_paren") # Parentheses
      start_loc = @tokens[@index].start_pos
      advance()
      node = parse()
      if has("right_paren") # Check parenthesis closure
        advance()
      else
        error_str = "Parse Error: Unmatched parenthesis for left parenthesis at location #{start_loc}"
        raise(error_str)
      end
      return node
    elsif has("to_float") # Int-to-Float
      to_float()
    elsif has("to_int") # Float-to-Int
      to_int()
    elsif has("sum") # Sum statistical function
      sum()
    elsif has("max") # Max statistical function
      max()
    elsif has("min") # Min statistical function
      min()
    elsif has("mean") # Mean statistical function
      mean()
    elsif has("hashtag") # cell-R-Value
      cellRight()
    elsif has("left_bracket") # Cell-L-Value
      cellLeft()
    elsif has("if")
      conditional()
    elsif has("for")
      for_each()
    elsif has("variable")
      variable()
    elsif has("tab")
      return
    else
      if @tokens[@index] == nil
        error_str = "\nParse Error: Unexpectedly reached EOF while attempting to parse #{@tokens[@tokens.length - 1].text} at position #{@tokens[@tokens.length - 1].start_pos}.\n"
        raise (error_str)
      end
      error_str = "\nParse Error: Unable to parse symbols starting at #{@tokens[@index].start_pos} and ending at #{@tokens[@index].end_pos}\n"
      error_str_2 = "Error token text: #{@tokens[@index].text}\n"
      raise (error_str + error_str_2)
    end
  end

  #Parse a variable (getting value).
  def variable()
    var_name = advance().text()
    node = VexAST::Variable.new(var_name)
    return node
  end

  #Parse a for-each
  def for_each()
    start_loc = @tokens[@index].start_pos
    advance()  # Go past "for" token
    iter_name = advance().text()  # Get name of variable that we are assigning each cell value to
    if has("in")  # Check to make sure that we have "in"
      advance()
    else
      error_str = "Parse Error: Unable to parse for-each block starting at #{start_loc}. Maybe you forgot \"in\"?"
      raise (error_str)
    end
    top_left_cell = parse()  # Get "top left" of cells to iterate through
    range_op = nil
    if has("inclusive_range")
      range_op = advance().text()
    elsif has("exclusive_range")
      range_op = advance().text()
    else
      error_str = "Parse Error: Unable to parse for-each block starting at #{start_loc}. Probable cause is bad range operator."
      raise (error_str) 
    end
    bottom_right_cell = parse()  # Get "bottom right" of cells to iterate through
    if has("newline")
      advance()
    end
    for_each_block = parse()  # Get block statement/conditional/whatever in our for-each.
    if has("newline")
      advance()
    end
    if has("end")
      advance()
    else
      error_str = "Parse Error: Unable to parse for-each block starting at #{start_loc}. Probably cause is missing \"end\"."
      raise(error_str)
    end
    node = VexAST::ForEach.new(iter_name, range_op, top_left_cell, bottom_right_cell, for_each_block)
    return node
  end

  #Parse a conditional
  def conditional()
    start_loc = @tokens[@index].start_pos
    advance()
    condition = parse()
    if has("newline")
      advance()
    else
      error_str = "Parse Error: Unexpected token reached in if-else block starting at #{start_loc}. Maybe you forgot a newline?"
      raise (error_str)
    end
    then_node = parse()
    if has("newline")
      advance()
    else
      error_str = "Parse Error: Unexpected token reached in if-else block starting at #{start_loc}. Maybe you forgot a newline?"
      raise (error_str)
    end
    if has("else")
      advance()
    else
      error_str = "Parse Error: Unexpected token reached in if-else block starting at #{start_loc}. Maybe you forgot else?"
      raise (error_str)
    end
    if has("newline")
      advance()
    else
      error_str = "Parse Error: Unexpected token reached in if-else block starting at #{start_loc}. Maybe you forgot a newline?"
      raise (error_str)
    end
    else_node = parse()
    if has("newline")
      advance()
    else
      error_str = "Parse Error: Unexpected token reached in if-else block starting at #{start_loc}. Maybe you forgot a newline?"
      raise (error_str)
    end
    if has("end")
      advance()
    else
      error_str = "Parse Error: Unexpected token reached in if-else block starting at #{start_loc}. Maybe you forgot end?"
      raise (error_str)
    end
    node = VexAST::Conditional.new(condition, then_node, else_node)
    return node
  end

  #Parse an int-to-float.
  def to_float()
    advance()
    left_paren = advance()
    if !(left_paren != nil) || left_paren.type.to_s != "left_paren"
      raise "Parse error: Missing left parenthesis for float cast call at #{tokens[@index - 2].end_pos}"
    end
    cast_val = parse()
    right_paren = advance()
    if !(right_paren != nil) || right_paren.type.to_s != "right_paren"
      raise "Parse error: Missing right parenthesis for float cast call at #{tokens[@index - 4].end_pos}"
    end
    node = VexAST::IntToFloat.new(cast_val)
    return node
  end

  #Parse a float-to-int.
  def to_int()
    advance()
    left_paren = advance()
    if !(left_paren != nil) || left_paren.type.to_s != "left_paren"
      raise "Parse error: Missing left parenthesis for float cast call at #{tokens[@index - 2].end_pos}"
    end
    advance()
    cast_val = parse()
    right_paren = advance()
    if !(right_paren != nil) || right_paren.type.to_s != "right_paren"
      raise "Parse error: Missing right parenthesis for float cast call at #{tokens[@index - 4].end_pos}"
    end
    node = VexAST::FloatToInt.new(cast_val)
    return node
  end

  #Parse a sum function call.
  def sum()
    advance()
    left_paren = advance()
    if !(left_paren != nil) || left_paren.type.to_s != "left_paren"
      raise "Parse error: Missing left parenthesis for sum call at #{tokens[@index - 2].end_pos}"
    end
    left_bracket1 = advance()
    if !(left_bracket1 != nil) || left_bracket1.type.to_s != "left_bracket"
      raise "Parse error: Missing left bracket for sum call at #{tokens[@index - 3].end_pos}"
    end
    cellAddr1 = parse()
    comma1 = advance()
    if !(comma1 != nil) || comma1.type.to_s != "comma"
      raise "Parse error: Missing comma for sum call at #{tokens[@index - 5].end_pos}"
    end
    cellAddr2 = parse()
    first = VexAST::CellAddress.new(cellAddr1.rawValue, cellAddr2.rawValue)
    right_bracket1 = advance()
    if !(right_bracket1 != nil) || right_bracket1.type.to_s != "right_bracket"
      raise "Parse error: Missing right bracket for sum call at #{tokens[@index - 7].end_pos}"
    end
    comma2 = advance()
    if !(comma2 != nil) || comma2.type.to_s != "comma"
      raise "Parse error: Missing comma for sum call at #{tokens[@index - 8].end_pos}"
    end
    left_bracket2 = advance()
    if !(left_bracket2 != nil) || left_bracket2.type.to_s != "left_bracket"
      raise "Parse error: Missing left bracket for sum call at #{tokens[@index - 9].end_pos}"
    end
    cellAddr3 = parse()
    comma3 = advance()
    if !(comma3 != nil) || comma3.type.to_s != "comma"
      raise "Parse error: Missing comma for sum call at #{tokens[@index - 11].end_pos}"
    end
    cellAddr4 = parse()
    second = VexAST::CellAddress.new(cellAddr3.rawValue, cellAddr4.rawValue)
    right_bracket2 = advance()
    if !(right_bracket2 != nil) || right_bracket2.type.to_s != "right_bracket"
      raise "Parse error: Missing right bracket for sum call at #{tokens[@index - 13].end_pos}"
    end
    right_paren2 = advance()
    if !(right_paren2 != nil) || right_paren2.type.to_s != "right_paren"
      raise "Parse error: Missing right parenthesis for sum call at #{tokens[@index - 14].end_pos}"
    end
    node = VexAST::Sum.new(first, second)
    return node
  end

  #Parse a max function call.
  def max()
    advance()
    left_paren = advance()
    if !(left_paren != nil) || left_paren.type.to_s != "left_paren"
      raise "Parse error: Missing left parenthesis for max call at #{tokens[@index - 2].end_pos}"
    end
    left_bracket1 = advance()
    if !(left_bracket1 != nil) || left_bracket1.type.to_s != "left_bracket"
      raise "Parse error: Missing left bracket for max call at #{tokens[@index - 3].end_pos}"
    end
    cellAddr1 = parse()
    comma1 = advance()
    if !(comma1 != nil) || comma1.type.to_s != "comma"
      raise "Parse error: Missing comma for max call at #{tokens[@index - 5].end_pos}"
    end
    cellAddr2 = parse()
    first = VexAST::CellAddress.new(cellAddr1.rawValue, cellAddr2.rawValue)
    right_bracket1 = advance()
    if !(right_bracket1 != nil) || right_bracket1.type.to_s != "right_bracket"
      raise "Parse error: Missing right bracket for max call at #{tokens[@index - 7].end_pos}"
    end
    comma2 = advance()
    if !(comma2 != nil) || comma2.type.to_s != "comma"
      raise "Parse error: Missing comma for max call at #{tokens[@index - 8].end_pos}"
    end
    left_bracket2 = advance()
    if !(left_bracket2 != nil) || left_bracket2.type.to_s != "left_bracket"
      raise "Parse error: Missing left bracket for max call at #{tokens[@index - 9].end_pos}"
    end
    cellAddr3 = parse()
    comma3 = advance()
    if !(comma3 != nil) || comma3.type.to_s != "comma"
      raise "Parse error: Missing comma for max call at #{tokens[@index - 11].end_pos}"
    end
    cellAddr4 = parse()
    second = VexAST::CellAddress.new(cellAddr3.rawValue, cellAddr4.rawValue)
    right_bracket2 = advance()
    if !(right_bracket2 != nil) || right_bracket2.type.to_s != "right_bracket"
      raise "Parse error: Missing right bracket for max call at #{tokens[@index - 13].end_pos}"
    end
    right_paren2 = advance()
    if !(right_paren2 != nil) || right_paren2.type.to_s != "right_paren"
      raise "Parse error: Missing right parenthesis for max call at #{tokens[@index - 14].end_pos}"
    end
    node = VexAST::Max.new(first, second)
    return node
  end

  #Parse a minimum function call.
  def min()
    advance()
    left_paren = advance()
    if !(left_paren != nil) || left_paren.type.to_s != "left_paren"
      raise "Parse error: Missing left parenthesis for min call at #{tokens[@index - 2].end_pos}"
    end
    left_bracket1 = advance()
    if !(left_bracket1 != nil) || left_bracket1.type.to_s != "left_bracket"
      raise "Parse error: Missing left bracket for min call at #{tokens[@index - 3].end_pos}"
    end
    cellAddr1 = parse()
    comma1 = advance()
    if !(comma1 != nil) || comma1.type.to_s != "comma"
      raise "Parse error: Missing comma for min call at #{tokens[@index - 5].end_pos}"
    end
    cellAddr2 = parse()
    first = VexAST::CellAddress.new(cellAddr1.rawValue, cellAddr2.rawValue)
    right_bracket1 = advance()
    if !(right_bracket1 != nil) || right_bracket1.type.to_s != "right_bracket"
      raise "Parse error: Missing right bracket for min call at #{tokens[@index - 7].end_pos}"
    end
    comma2 = advance()
    if !(comma2 != nil) || comma2.type.to_s != "comma"
      raise "Parse error: Missing comma for min call at #{tokens[@index - 8].end_pos}"
    end
    left_bracket2 = advance()
    if !(left_bracket2 != nil) || left_bracket2.type.to_s != "left_bracket"
      raise "Parse error: Missing left bracket for min call at #{tokens[@index - 9].end_pos}"
    end
    cellAddr3 = parse()
    comma3 = advance()
    if !(comma3 != nil) || comma3.type.to_s != "comma"
      raise "Parse error: Missing comma for min call at #{tokens[@index - 11].end_pos}"
    end
    cellAddr4 = parse()
    second = VexAST::CellAddress.new(cellAddr3.rawValue, cellAddr4.rawValue)
    right_bracket2 = advance()
    if !(right_bracket2 != nil) || right_bracket2.type.to_s != "right_bracket"
      raise "Parse error: Missing right bracket for min call at #{tokens[@index - 13].end_pos}"
    end
    right_paren2 = advance()
    if !(right_paren2 != nil) || right_paren2.type.to_s != "right_paren"
      raise "Parse error: Missing right parenthesis for min call at #{tokens[@index - 14].end_pos}"
    end
    node = VexAST::Min.new(first, second)
    return node
  end

  #Parse a mean function call.
  def mean()
    advance()
    left_paren = advance()
    if !(left_paren != nil) || left_paren.type.to_s != "left_paren"
      raise "Parse error: Missing left parenthesis for mean call at #{tokens[@index - 2].end_pos}"
    end
    left_bracket1 = advance()
    if !(left_bracket1 != nil) || left_bracket1.type.to_s != "left_bracket"
      raise "Parse error: Missing left bracket for mean call at #{tokens[@index - 3].end_pos}"
    end
    cellAddr1 = parse()
    comma1 = advance()
    if !(comma1 != nil) || comma1.type.to_s != "comma"
      raise "Parse error: Missing comma for mean call at #{tokens[@index - 5].end_pos}"
    end
    cellAddr2 = parse()
    first = VexAST::CellAddress.new(cellAddr1.rawValue, cellAddr2.rawValue)
    right_bracket1 = advance()
    if !(right_bracket1 != nil) || right_bracket1.type.to_s != "right_bracket"
      raise "Parse error: Missing right bracket for mean call at #{tokens[@index - 7].end_pos}"
    end
    comma2 = advance()
    if !(comma2 != nil) || comma2.type.to_s != "comma"
      raise "Parse error: Missing comma for mean call at #{tokens[@index - 8].end_pos}"
    end
    left_bracket2 = advance()
    if !(left_bracket2 != nil) || left_bracket2.type.to_s != "left_bracket"
      raise "Parse error: Missing left bracket for mean call at #{tokens[@index - 9].end_pos}"
    end
    cellAddr3 = parse()
    comma3 = advance()
    if !(comma3 != nil) || comma3.type.to_s != "comma"
      raise "Parse error: Missing comma for mean call at #{tokens[@index - 11].end_pos}"
    end
    cellAddr4 = parse()
    second = VexAST::CellAddress.new(cellAddr3.rawValue, cellAddr4.rawValue)
    right_bracket2 = advance()
    if !(right_bracket2 != nil) || right_bracket2.type.to_s != "right_bracket"
      raise "Parse error: Missing right bracket for mean call at #{tokens[@index - 13].end_pos}"
    end
    right_paren2 = advance()
    if !(right_paren2 != nil) || right_paren2.type.to_s != "right_paren"
      raise "Parse error: Missing right parenthesis for mean call at #{tokens[@index - 14].end_pos}"
    end
    node = VexAST::Mean.new(first, second)
    return node
  end

  #Parse a cellRValue (get value from cell).
  def cellRight()
    advance()
    left_bracket = advance()
    if !(left_bracket != nil) || left_bracket.type.to_s != "left_bracket"
      raise "Parse error: Missing left bracket for cellRValue call at #{tokens[@index - 2].end_pos}"
    end
    row = parse()
    comma = advance()
    if !(comma != nil) || comma.type.to_s != "comma"
      raise "Parse error: Missing comma for cellRvalue call at #{tokens[@index - 4].end_pos}"
    end
    column = parse()
    right_bracket = advance()
    if !(right_bracket != nil) || right_bracket.type.to_s != "right_bracket"
      raise "Parse error: Missing right bracket for cellRValue call at #{tokens[@index - 6].end_pos}"
    end
    cellRVal = VexAST::CellRValue.new(row, column)
    return cellRVal
  end

  #Parse a cellLValue (address of cell).
  def cellLeft()
    left_bracket = advance()
    if !(left_bracket != nil) || left_bracket.type.to_s != "left_bracket"
      raise "Parse error: Missing left bracket for cellLValue call at #{tokens[@index - 1].end_pos}"
    end
    row = parse()
    comma = advance()
    if !(comma != nil) || comma.type.to_s != "comma"
      raise "Parse error: Missing comma for cellLvalue call at #{tokens[@index - 3].end_pos}"
    end
    column = parse()
    right_bracket = advance()
    if !(right_bracket != nil) || right_bracket.type.to_s != "right_bracket"
      raise "Parse error: Missing right bracket for cellRValue call at #{tokens[@index - 5].end_pos}"
    end
    cellRVal = VexAST::CellLValue.new(row, column)
    return cellRVal
  end
end