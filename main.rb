require_relative 'vex_ast.rb'
require_relative 'serialize.rb'
require_relative 'evaluate.rb'
require_relative 'grid.rb'

intTest = VexAST::Integer.new(6)
floatTest = VexAST::Float.new(6.5)
boolTest = VexAST::Boolean.new('true')
stringTest = VexAST::String.new("hello")
cellAddrTest = VexAST::CellAddress.new(5, 7)
cellAddrTest2 = VexAST::CellAddress.new(8, 9)
intTest2 = VexAST::Integer.new(5)
addTest = VexAST::Add.new(intTest, intTest2)
subTest = VexAST::Subtract.new(intTest, intTest2)
multTest = VexAST::Multiply.new(intTest, intTest2)
divTest = VexAST::Divide.new(intTest, intTest2)
modTest = VexAST::Modulo.new(intTest, intTest2)
exponentiationTest = VexAST::Exponentiation.new(intTest, intTest2)
negateTest = VexAST::Negate.new(intTest)
logicalAndTest = VexAST::LogicalAnd.new(intTest, intTest2)
logicalOrTest = VexAST::LogicalOr.new(intTest, intTest2)
logicalNotTest = VexAST::LogicalNot.new(intTest)
cellLValueTest = VexAST::CellLValue.new(intTest, intTest2)
cellRValueTest = VexAST::CellRValue.new(intTest, intTest2)
bitwiseAndTest = VexAST::BitwiseAnd.new(intTest, intTest2)
bitwiseOrTest = VexAST::BitwiseOr.new(intTest, intTest2)
bitwiseXorTest = VexAST::BitwiseXor.new(intTest, intTest2)
bitwiseNotTest = VexAST::BitwiseNot.new(intTest)
leftShiftTest = VexAST::LeftShift.new(intTest, intTest)
rightShiftTest = VexAST::RightShift.new(intTest, intTest)
equalTest = VexAST::Equal.new(intTest, intTest2)
notEqualTest = VexAST::NotEqual.new(intTest, intTest2)
lessThanTest = VexAST::LessThan.new(intTest, intTest2)
lessThanOrEqualToTest = VexAST::LessOrEqualTo.new(intTest, intTest2)
greaterThanTest = VexAST::GreaterThan.new(intTest, intTest2)
greaterOrEqualToTest = VexAST::GreaterOrEqualTo.new(intTest, intTest2)
floatToIntTest = VexAST::FloatToInt.new(floatTest)
intToFloatTest = VexAST::IntToFloat.new(intTest)
minTest = VexAST::Min.new(cellAddrTest, cellAddrTest2)
maxTest = VexAST::Max.new(cellAddrTest, cellAddrTest2)
meanTest = VexAST::Mean.new(cellAddrTest, cellAddrTest2)
sumTest = VexAST::Sum.new(cellAddrTest, cellAddrTest2)

serializer = Serialize.new()

puts 'SERIALIZER TESTS'
puts
puts serializer.visit_integer(intTest)
puts serializer.visit_float(floatTest)
puts serializer.visit_boolean(boolTest)
puts serializer.visit_string(stringTest)
puts serializer.visit_cellAddress(cellAddrTest)
puts serializer.visit_add(addTest)
puts serializer.visit_subtract(subTest)
puts serializer.visit_multiply(multTest)
puts serializer.visit_divide(divTest)
puts serializer.visit_modulo(modTest)
puts serializer.visit_exponentiation(exponentiationTest)
puts serializer.visit_negate(negateTest)
puts serializer.visit_logicalAnd(logicalAndTest)
puts serializer.visit_logicalOr(logicalOrTest)
puts serializer.visit_logicalNot(logicalNotTest)
puts serializer.visit_cellLValue(cellLValueTest)
puts serializer.visit_cellRValue(cellRValueTest)
puts serializer.visit_bitwiseAnd(bitwiseAndTest)
puts serializer.visit_bitwiseOr(bitwiseOrTest)
puts serializer.visit_bitwiseXor(bitwiseXorTest)
puts serializer.visit_bitwiseNot(bitwiseNotTest)
puts serializer.visit_leftShift(leftShiftTest)
puts serializer.visit_rightShift(rightShiftTest)
puts serializer.visit_equal(equalTest)
puts serializer.visit_notEqual(notEqualTest)
puts serializer.visit_lessThan(lessThanTest)
puts serializer.visit_lessOrEqualTo(lessThanOrEqualToTest)
puts serializer.visit_greaterThan(greaterThanTest)
puts serializer.visit_greaterOrEqualTo(greaterOrEqualToTest)
puts serializer.visit_floatToInt(floatToIntTest)
puts serializer.visit_intToFloat(intToFloatTest)
puts serializer.visit_min(minTest)
puts serializer.visit_max(maxTest)
puts serializer.visit_mean(meanTest)
puts serializer.visit_sum(sumTest)
puts
puts 'END SERIALIZER TESTS'
puts
puts '--------------------'
puts

eval = Evaluate.new
num7 = VexAST::Integer.new(7)
num4 = VexAST::Integer.new(4)
num3 = VexAST::Integer.new(3)
num5 = VexAST::Integer.new(5)
num8 = VexAST::Integer.new(8)
num6 = VexAST::Integer.new(6)
num1 = VexAST::Integer.new(1)
num2 = VexAST::Integer.new(2)
num12 = VexAST::Integer.new(12)
float33 = VexAST::Float.new(3.3)
float32 = VexAST::Float.new(3.2)

puts
puts 'MILESTONE TESTS'
puts
puts 'Arithmetic: (7 * 4 + 3) % 12 = '
puts 'Arithmetic negation and cell rvalues: #[3, 1] * -#[2, 1]'
puts 'Rvalue lookup and shift: #[1 + 1, 4] << 3'
puts 'Rvalue lookup and comparison: #[0, 0] < #[0, 1]'
puts 'Logic and comparison: !(3.3 > 3.2) = '
puts 'Double negation: --(6 * 8) = '
puts 'Bitwise operations: ~5 | ~8 = '
puts 'Sum: sum([1, 2], [5, 3]) = '
puts 'Mean: mean([1, 2], [5, 3]) = '
puts 'Min: min([1, 2], [5, 3]) = '
puts 'Max: max([1, 2], [5, 3])'
puts 'Casting: float(7) / 2'
puts
puts 'END MILESTONE TESTS'
puts
puts '-------------------'
puts
puts 'START GRID TESTS'
puts

#Grid Tests
grid_test = Grid.new(2, 2)
grid_test.set_cell(0, 0, add_node)
puts grid_test.get_cell(0, 0)
