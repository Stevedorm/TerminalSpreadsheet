require_relative 'lexer.rb'
require_relative 'parser.rb'
require_relative 'vex_ast.rb'
require_relative 'evaluate.rb'
require_relative 'serialize.rb'
require_relative 'grid.rb'
require_relative 'runtime.rb'

milestone_grid = Grid.new(5, 5)
milestone_runtime = Runtime.new(milestone_grid)
milestone_evaluator = Evaluate.new(milestone_runtime)
milestone_serializer = Serialize.new()
milestone_grid.set_runtime(milestone_runtime)



# ARITHMETIC
puts
puts "Arithmetic"
lex1 = Lexer.new("(5 + 2) * 3 % 4")
pars1 = Parser.new(lex1.tokens)
ast1 = pars1.parse_top_level
evaluated = milestone_evaluator.visit(ast1)
puts "Expected -> 1\n"
puts "Actual   -> #{evaluated.rawValue.to_s}\n"
puts "VexAST Below\n"
puts ast1.inspect
puts
puts "-----------------------------------------------------------------------------------------------------------------------------------------------------------"

int1 = VexAST::Integer.new(1)
milestone_grid.set_cell(0, 0, int1)

# Rvalue lookup and shift
puts
puts "Rvalue lookup and shift"
lex2 = Lexer.new("#[0, 0] + 3")
pars2 = Parser.new(lex2.tokens)
ast2 = pars2.parse_top_level
evaluated = milestone_evaluator.visit(ast2)
puts "Expected -> 4\n"
puts "Actual   -> #{evaluated.rawValue.to_s}\n"
puts "VexAST Below"
puts ast2.inspect
puts
puts "-----------------------------------------------------------------------------------------------------------------------------------------------------------"

int2 = VexAST::Integer.new(2)
milestone_grid.set_cell(1, 1, int2)


# Rvalue lookup and comparison
puts
puts "Rvalue lookup and comparison"
lex3 = Lexer.new("#[1 - 1, 0] < #[1 * 1, 1]")
pars3 = Parser.new(lex3.tokens)
ast3 = pars3.parse_top_level
evaluated = milestone_evaluator.visit(ast3)
puts "Expected -> true\n"
puts "Actual   -> #{evaluated.rawValue}\n"
puts "VexAST Below"
puts ast3.inspect
puts
puts "-----------------------------------------------------------------------------------------------------------------------------------------------------------"

# Logic and comparison
puts
puts "Logic and comparison"
lex4 = Lexer.new("(5 > 3) && !(2 > 8)")
pars4 = Parser.new(lex4.tokens)
ast4 = pars4.parse_top_level
evaluated = milestone_evaluator.visit(ast4)
puts "Expected -> true\n"
puts "Actual:  -> #{evaluated.rawValue.to_s}\n"
puts "VexAST Below"
puts ast4.inspect
puts
puts "-----------------------------------------------------------------------------------------------------------------------------------------------------------"

for i in (0...3)
  for j in (0...3)
    cur = VexAST::Integer.new(j + 1)
    milestone_grid.set_cell(i, j, cur)
  end
end

puts
puts "Sum"
lex5 = Lexer.new("1 + sum([0, 0], [2, 2])")
pars5 = Parser.new(lex5.tokens)
ast5 = pars5.parse_top_level
evaluated = milestone_evaluator.visit(ast5)
puts "Expected -> 19\n"
puts "Actual   -> #{evaluated.rawValue.to_s}\n"
puts "VexAST Below"
puts ast5.inspect
puts
puts "-----------------------------------------------------------------------------------------------------------------------------------------------------------"

# Casting
puts
puts "Casting"
lex6 = Lexer.new("float(10) / 4.0")
pars6 = Parser.new(lex6.tokens)
ast6 = pars6.parse_top_level
evaluated = milestone_evaluator.visit(ast6)
puts "Expected -> 2.5\n"
puts "Actual   -> #{evaluated.rawValue.to_s}\n"
puts "VexAST Below"
puts ast6.inspect
puts
puts "-----------------------------------------------------------------------------------------------------------------------------------------------------------"

# Exponentiation
puts
puts "Exponentiation"
lex7 = Lexer.new("2 ** 3 ** 2")
pars7 = Parser.new(lex7.tokens)
ast7 = pars7.parse_top_level
evaluated = milestone_evaluator.visit(ast7)
puts "Expected -> 512\n" 
puts "Actual   -> #{evaluated.rawValue.to_s}\n"
puts "VexAST Below"
puts ast7.inspect
puts
puts "-----------------------------------------------------------------------------------------------------------------------------------------------------------"

# Negation and bitwise and
puts
puts "Negation and Bitwise And"
lex8 = Lexer.new("45 & ---(1 + 3)")
pars8 = Parser.new(lex8.tokens)
ast8 = pars8.parse_top_level
evaluated = milestone_evaluator.visit(ast8)
puts "Expected -> 44\n" 
puts "Actual   -> #{evaluated.rawValue.to_s}\n"
puts "VexAST Below"
puts ast8.inspect
puts
puts "-----------------------------------------------------------------------------------------------------------------------------------------------------------"

# Max
int19 = VexAST::Integer.new(19)
milestone_grid.set_cell(1, 1, int19)

puts
puts "Max"
lex9 = Lexer.new("max([0, 0], [2, 2])")
pars9 = Parser.new(lex9.tokens)
ast9 = pars9.parse_top_level
evaluated = milestone_evaluator.visit(ast9)
puts "Expected -> 19\n" 
puts "Actual   -> #{evaluated.get_most_recent_primitive.rawValue}\n"
puts "VexAST Below"
puts ast8.inspect
puts
puts "-----------------------------------------------------------------------------------------------------------------------------------------------------------"

# Min
int_1 = VexAST::Integer.new(-1)
milestone_grid.set_cell(1, 1, int_1)

puts
puts "Min"
lex10 = Lexer.new("min([0, 0], [2, 2])")
pars10 = Parser.new(lex10.tokens)
ast10 = pars10.parse_top_level
evaluated = milestone_evaluator.visit(ast10)
puts "Expected -> -1\n" 
puts "Actual   -> #{evaluated.get_most_recent_primitive.rawValue}\n"
puts "VexAST Below"
puts ast8.inspect
puts
puts "-----------------------------------------------------------------------------------------------------------------------------------------------------------"

# Mean
for i in (0...3)
  for j in (0...3)
    cur = VexAST::Integer.new(j + 1)
    milestone_grid.set_cell(i, j, cur)
  end
end

puts
puts "Mean"
lex11 = Lexer.new("mean([0, 0], [2, 2])")
pars11 = Parser.new(lex11.tokens)
ast11 = pars11.parse_top_level
evaluated = milestone_evaluator.visit(ast11)
puts "Expected -> 2\n" 
puts "Actual   -> #{evaluated.rawValue}\n"
puts "VexAST Below"
puts ast8.inspect
puts
puts "-----------------------------------------------------------------------------------------------------------------------------------------------------------"

#Extra Tests
puts
puts "Negation and Bitwise And With Exponents"
lex8 = Lexer.new("17 & ----(1 + 3) ** 2")
pars8 = Parser.new(lex8.tokens)
ast8 = pars8.parse_top_level
evaluated = milestone_evaluator.visit(ast8)
puts "Expected -> 16\n"
puts "Actual   -> #{evaluated.rawValue.to_s}\n"
puts "VexAST Below"
puts ast8.inspect
puts
puts "-----------------------------------------------------------------------------------------------------------------------------------------------------------"

#Conditional Test
puts
puts "Conditional Test"
lex9 = Lexer.new("if 10 < 9\n10\nelse\n9\nend")
pars9 = Parser.new(lex9.tokens)
ast9 = pars9.parse_top_level
evaluated = milestone_evaluator.visit(ast9)
puts "#{evaluated.rawValue.to_s}"


# Failure Tests

puts
puts "Destined To Fail"
puts "45 -& ---(1 + 3)"
lex8 = Lexer.new("45 -& ---(1 + 3)") # says error at &
pars8 = Parser.new(lex8.tokens)
ast8 = pars8.parse_top_level