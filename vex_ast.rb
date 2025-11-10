module VexAST

  class Integer
    attr_reader :rawValue

    def initialize(rawValue)
      @rawValue = rawValue
    end

    def visit(visitor)
      visitor.visit_integer(self)
    end
  end

  class Float
    attr_reader :rawValue

    def initialize(rawValue)
      @rawValue = rawValue
    end

    def visit(visitor)
      visitor.visit_float(self)
    end

  end

  class Boolean
    attr_reader :rawValue

    def initialize(rawValue)
      @rawValue = rawValue
    end

    def visit(visitor)
      visitor.visit_boolean(self)
    end
  end

  class String
    attr_reader :rawValue

    def initialize(rawValue)
      @rawValue = rawValue
    end

    def visit(visitor)
      visitor.visit_string(self)
    end
  end

  class CellAddress
    attr_reader :rowVal
    attr_reader :colVal
    
    def initialize(rowVal, colVal)
      @rowVal = rowVal
      @colVal = colVal
    end

    def visit(visitor)
      visitor.visit_cellAddress(self)
    end
  end

  class Add
    attr_reader :leftNode
    attr_reader :rightNode

    def initialize(leftNode, rightNode)
      @leftNode = leftNode
      @rightNode = rightNode
    end

    def visit(visitor)
      visitor.visit_add(self)
    end
  end

  class Subtract
    attr_reader :leftNode
    attr_reader :rightNode

    def initialize(leftNode, rightNode)
      @leftNode = leftNode
      @rightNode = rightNode
    end

    def visit(visitor)
      visitor.visit_subtract(self)
    end
  end

  class Multiply
    attr_reader :leftNode
    attr_reader :rightNode

    def initialize(leftNode, rightNode)
      @leftNode = leftNode
      @rightNode = rightNode
    end

    def visit(visitor)
      visitor.visit_multiply(self)
    end
  end

  class Divide
    attr_reader :leftNode
    attr_reader :rightNode

    def initialize(leftNode, rightNode)
      @leftNode = leftNode
      @rightNode = rightNode
    end

    def visit(visitor)
      visitor.visit_divide(self)
    end
  end

  class Modulo
    attr_reader :leftNode
    attr_reader :rightNode

    def initialize(leftNode, rightNode)
      @leftNode = leftNode
      @rightNode = rightNode
    end

    def visit(visitor)
      visitor.visit_modulo(self)
    end
  end

  class Exponentiation
    attr_reader :leftNode
    attr_reader :rightNode

    def initialize(leftNode, rightNode)
      @leftNode = leftNode
      @rightNode = rightNode
    end

    def visit(visitor)
      visitor.visit_exponentiation(self)
    end
  end

  class Negate
    attr_reader :node

    def initialize(node)
      @node = node
    end

    def visit(visitor)
      visitor.visit_negate(self)
    end
  end

  class LogicalAnd
    attr_reader :leftNode
    attr_reader :rightNode

    def initialize(leftNode, rightNode)
      @leftNode = leftNode
      @rightNode = rightNode
    end

    def visit(visitor)
      visitor.visit_logicalAnd(self)
    end
  end

  class LogicalOr
    attr_reader :leftNode
    attr_reader :rightNode

    def initialize(leftNode, rightNode)
      @leftNode = leftNode
      @rightNode = rightNode
    end

    def visit(visitor)
      visitor.visit_logicalOr(self)
    end
  end

  class LogicalNot
    attr_reader :node

    def initialize(node)
      @node = node
    end

    def visit(visitor)
      visitor.visit_logicalNot(self)
    end
  end

  class CellLValue
    attr_reader :leftNode
    attr_reader :rightNode

    def initialize(leftNode, rightNode)
      @leftNode = leftNode
      @rightNode = rightNode
    end

    def visit(visitor)
      visitor.visit_cellLValue(self)
    end
  end

  class CellRValue
    attr_reader :leftNode
    attr_reader :rightNode

    def initialize(leftNode, rightNode)
      @leftNode = leftNode
      @rightNode = rightNode
    end

    def visit(visitor)
      visitor.visit_cellRValue(self)
    end
  end

  class BitwiseAnd
    attr_reader :leftNode
    attr_reader :rightNode

    def initialize(leftNode, rightNode)
      @leftNode = leftNode
      @rightNode = rightNode
    end

    def visit(visitor)
      visitor.visit_bitwiseAnd(self)
    end
  end

  class BitwiseOr
    attr_reader :leftNode
    attr_reader :rightNode

    def initialize(leftNode, rightNode)
      @leftNode = leftNode
      @rightNode = rightNode
    end

    def visit(visitor)
      visitor.visit_bitwiseOr(self)
    end
  end

  class BitwiseXor
    attr_reader :leftNode
    attr_reader :rightNode

    def initialize(leftNode, rightNode)
      @leftNode = leftNode
      @rightNode = rightNode
    end

    def visit(visitor)
      visitor.visit_bitwiseXor(self)
    end
  end

  class BitwiseNot
    attr_reader :node

    def initialize(node)
      @node = node
    end

    def visit(visitor)
      visitor.visit_bitwiseNot(self)
    end
  end

  class LeftShift
    attr_reader :leftNode, :rightNode

    def initialize(leftNode, rightNode)
      @leftNode = leftNode
      @rightNode = rightNode
    end

    def visit(visitor)
      visitor.visit_leftShift(self)
    end
  end

  class RightShift
    attr_reader :leftNode, :rightNode

    def initialize(leftNode, rightNode)
      @leftNode = leftNode
      @rightNode = rightNode
    end

    def visit(visitor)
      visitor.visit_rightShift(self)
    end
  end

  class Equal
    attr_reader :leftNode
    attr_reader :rightNode

    def initialize(leftNode, rightNode)
      @leftNode = leftNode
      @rightNode = rightNode
    end

    def visit(visitor)
      visitor.visit_equal(self)
    end
  end

  class NotEqual
    attr_reader :leftNode
    attr_reader :rightNode

    def initialize(leftNode, rightNode)
      @leftNode = leftNode
      @rightNode = rightNode
    end

    def visit(visitor)
      visitor.visit_notEqual(self)
    end
  end

  class LessThan
    attr_reader :leftNode
    attr_reader :rightNode

    def initialize(leftNode, rightNode)
      @leftNode = leftNode
      @rightNode = rightNode
    end

    def visit(visitor)
      visitor.visit_lessThan(self)
    end
  end

  class LessOrEqualTo
    attr_reader :leftNode
    attr_reader :rightNode

    def initialize(leftNode, rightNode)
      @leftNode = leftNode
      @rightNode = rightNode
    end

    def visit(visitor)
      visitor.visit_lessOrEqualTo(self)
    end
  end

  class GreaterThan
    attr_reader :leftNode
    attr_reader :rightNode

    def initialize(leftNode, rightNode)
      @leftNode = leftNode
      @rightNode = rightNode
    end

    def visit(visitor)
      visitor.visit_greaterThan(self)
    end
  end

  class GreaterOrEqualTo
    attr_reader :leftNode
    attr_reader :rightNode

    def initialize(leftNode, rightNode)
      @leftNode = leftNode
      @rightNode = rightNode
    end

    def visit(visitor)
      visitor.visit_greaterOrEqualTo(self)
    end
  end

  class FloatToInt
    attr_reader :node

    def initialize(node)
      @node = node
    end

    def visit(visitor)
      visitor.visit_floatToInt(self)
    end
  end

  class IntToFloat
    attr_reader :node

    def initialize(node)
      @node = node
    end

    def visit(visitor)
      visitor.visit_intToFloat(self)
    end
  end

  class Min
    attr_reader :leftNode
    attr_reader :rightNode

    def initialize(leftNode, rightNode)
      @leftNode = leftNode
      @rightNode = rightNode
    end

    def visit(visitor)
      visitor.visit_min(self)
    end
  end

  class Max
    attr_reader :leftNode
    attr_reader :rightNode

    def initialize(leftNode, rightNode)
      @leftNode = leftNode
      @rightNode = rightNode
    end

    def visit(visitor)
      visitor.visit_max(self)
    end
  end

  class Mean
    attr_reader :leftNode
    attr_reader :rightNode

    def initialize(leftNode, rightNode)
      @leftNode = leftNode
      @rightNode = rightNode
    end

    def visit(visitor)
      visitor.visit_mean(self)
    end
  end

  class Sum
    attr_reader :leftNode
    attr_reader :rightNode

    def initialize(leftNode, rightNode)
      @leftNode = leftNode
      @rightNode = rightNode
    end

    def visit(visitor)
      visitor.visit_sum(self)
    end
  end

  class Conditional
    attr_reader :condition
    attr_reader :then_val
    attr_reader :else_val

    def initialize(condition, then_val, else_val)
      @condition = condition
      @then_val = then_val
      @else_val = else_val
    end

    def visit(visitor)
      visitor.visit_conditional(self)
    end
  end

  # For block, instantiate the class to put lines/statements in an array, 
  # then parse and lex it line by line.

  class Block # Expressions is an array of statements
    attr_reader :statements 

    def initialize(statements)
      @statements  = statements
    end

    def visit(visitor)
      visitor.visit_block(self)
    end
  end
  
  class Assignment
    attr_reader :name
    attr_reader :val

    def initialize(name, val)
      @name = name
      @val = val
    end

    def visit(visitor)
      visitor.visit_assignment(self)
    end
  end
  
  class Variable
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def visit(visitor)
      visitor.visit_variable(self)
    end
  end

  # Make a for-each abstraction in your model classes that stores the name 
  # of the iterator, the starting cell address, the ending cell address, and
  # the block. It iterates through the two-dimensional window of cells and
  # assigns each cell's value to a local variable with the given name. The 
  # block is evaluated for each cell in the given window. The value returned 
  # by the block on the final iteration is the value returned by the larger loop.
  class ForEach
    attr_reader :iter
    attr_reader :startAddress
    attr_reader :endAddress
    attr_reader :block
    attr_reader :rangeOp # string form like "inclusive_range" like token from lexer

    def initialize(iter, rangeOp, startAddress, endAddress, block)
      @iter = iter
      @rangeOp = rangeOp
      @startAddress = startAddress
      @endAddress = endAddress
      @block = block
    end

    def visit(visitor)
      visitor.visit_for_each(self)
    end
  end


end