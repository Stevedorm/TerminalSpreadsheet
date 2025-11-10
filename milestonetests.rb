require_relative 'vex_ast.rb'
require_relative 'evaluate.rb'
require_relative 'serialize.rb'
require_relative 'grid.rb'
require_relative 'runtime.rb'

#Milestone Tests
#Test 1
milestone_grid = Grid.new(5, 5)
milestone_runtime = Runtime.new(milestone_grid)
milestone_evaluator = Evaluate.new(milestone_runtime)
milestone_serializer = Serialize.new()
milestone_grid.set_runtime(milestone_runtime)
int7 = VexAST::Integer.new(7)
int4 = VexAST::Integer.new(4)
int3 = VexAST::Integer.new(3)
int12 = VexAST::Integer.new(12)
mult1 = VexAST::Multiply.new(int7, int4)
add1 = VexAST::Add.new(mult1, int3)
mod1 = VexAST::Modulo.new(add1, int12)
milestone_grid.set_cell(0, 0, mod1)
puts "Serialize result of (7 * 4 + 3) % 12 -> #{milestone_serializer.visit(mod1)}"
puts "Result of (7 * 4 + 3) % 12; Expected: 7, Actual: -> #{milestone_grid.get_cell(0, 0).get_most_recent_primitive.rawValue}"
puts

#Test 2
milestone_grid.set_cell(3, 1, int7)
milestone_grid.set_cell(2, 1, int4)
int1 = VexAST::Integer.new(1)
int2 = VexAST::Integer.new(2)
cell_r_val1 = VexAST::CellRValue.new(int3, int1)
cell_r_val2 = VexAST::CellRValue.new(int2, int1)
negate1 = VexAST::Negate.new(cell_r_val2)
add2 = VexAST::Multiply.new(cell_r_val1, negate1)
milestone_grid.set_cell(0, 0, add2)
puts "Serialize result = #{milestone_serializer.visit(add2)}"
puts "Result of 7 * -4; Expected = -28, Actual = #{milestone_grid.get_cell(0, 0).get_most_recent_primitive.rawValue}"
puts

#Test 3
milestone_grid.set_cell(2, 4, int4)
add3 = VexAST::Add.new(int1, int1)
cell_r_val3 = VexAST::CellRValue.new(add3, int4)
left_shift1 = VexAST::LeftShift.new(cell_r_val3, int3)
milestone_grid.set_cell(0, 0, left_shift1)
puts "Serialize result = #{milestone_grid.get_cell(0, 0).get_string_rep}"
puts "Result of #[1 + 1, 4] << 3; Expected: 32, Actual: #{milestone_grid.get_cell(0, 0).get_most_recent_primitive.rawValue}"
puts

#Test 4
milestone_grid.set_cell(0, 0, int4)
milestone_grid.set_cell(0, 1, int3)
int0 = VexAST::Integer.new(0)
cell_r_val4 = VexAST::CellRValue.new(int0, int0)
cell_r_val5 = VexAST::CellRValue.new(int0, int1)
less_than1 = VexAST::LessThan.new(cell_r_val4, cell_r_val5)
milestone_grid.set_cell(1, 1, less_than1)
puts "Serialize result = #{milestone_grid.get_cell(1, 1).get_string_rep}"
puts "Result of 4 < 3; Expected: false, Actual: #{milestone_grid.get_cell(1, 1).get_most_recent_primitive.rawValue}"
puts

#Test 5
float3_3 = VexAST::Float.new(3.3)
float3_2 = VexAST::Float.new(3.2)
greater_than1 = VexAST::GreaterThan.new(float3_3, float3_2)
logical_not1 = VexAST::LogicalNot.new(greater_than1)
milestone_grid.set_cell(0, 0, logical_not1)
puts "Serialize result = #{milestone_grid.get_cell(0, 0).get_string_rep}"
puts "Result of !(3.3 > 3.2); Expected: false, Actual: #{milestone_grid.get_cell(0, 0).get_most_recent_primitive.rawValue}"
puts

#Test 6
int6 = VexAST::Integer.new(6)
int8 = VexAST::Integer.new(8)
mult2 = VexAST::Multiply.new(int6, int8)
negate2 = VexAST::Negate.new(mult2)
negate3 = VexAST::Negate.new(negate2)
milestone_grid.set_cell(0, 0, negate3)
puts "Serialize result = #{milestone_grid.get_cell(0, 0).get_string_rep}"
puts "Result of --(6 * 8); Expected: 48, Actual: #{milestone_grid.get_cell(0, 0).get_most_recent_primitive.rawValue}"
puts

#Test 7
int5 = VexAST::Integer.new(5)
not1 = VexAST::BitwiseNot.new(int5)
not2 = VexAST::BitwiseNot.new(int8)
or1 = VexAST::BitwiseOr.new(not1, not2)
milestone_grid.set_cell(0, 0, or1)
puts "Serialize result = #{milestone_grid.get_cell(0, 0).get_string_rep}"
puts "Result of ~5 | ~8; Expected: -1, Actual: #{milestone_grid.get_cell(0, 0).get_most_recent_primitive.rawValue}"

#Test 8
milestone_grid2 = Grid.new(6, 6)
milestone_runtime2 = Runtime.new(milestone_grid2)
milestone_evaluator2 = Evaluate.new(milestone_runtime2)
milestone_serializer2 = Serialize.new()
milestone_grid2.set_runtime(milestone_runtime2)
milestone_grid2.set_cell(1, 2, int5)
milestone_grid2.set_cell(5, 2, int8)
milestone_grid2.set_cell(1, 3, int4)
milestone_grid2.set_cell(5, 3, int12)
milestone_grid2.set_cell(3, 3, int6)
cell_addr1 = VexAST::CellAddress.new(1, 2)
cell_addr2 = VexAST::CellAddress.new(5, 3)
sum1 = VexAST::Sum.new(cell_addr1, cell_addr2)
milestone_grid2.set_cell(0, 0, sum1)
puts "Serialize result = #{milestone_grid2.get_cell(0, 0).get_string_rep}"
puts "Result of Sum((1, 2), (5, 3)); Expected: 35, Actual: #{milestone_grid2.get_cell(0, 0).get_most_recent_primitive.rawValue}"
puts

#Test 9
min1 = VexAST::Min.new(cell_addr1, cell_addr2)
milestone_grid2.set_cell(0, 0, min1)
puts "Serialize result = #{milestone_grid2.get_cell(0, 0).get_string_rep}"
puts "Result of Min((1, 2), (5, 3)); Expected: 4, Actual: #{milestone_grid2.get_cell(0, 0).get_most_recent_primitive.get_most_recent_primitive.rawValue}"
puts

#Test 10
max1 = VexAST::Max.new(cell_addr1, cell_addr2)
milestone_grid2.set_cell(0, 0, max1)
puts "Serialize result = #{milestone_grid2.get_cell(0, 0).get_string_rep}"
puts "Result of Max((1, 2), (5, 3)); Expected: 12, Actual: #{milestone_grid2.get_cell(0, 0).get_most_recent_primitive.get_most_recent_primitive.rawValue}"
puts

#Test 11
mean1 = VexAST::Mean.new(cell_addr1, cell_addr2)
milestone_grid2.set_cell(0, 0, mean1)
puts "Serialize result = #{milestone_grid2.get_cell(0, 0).get_string_rep}"
puts "Result of Mean((1, 2), (5, 3)); Expected: 7, Actual: #{milestone_grid2.get_cell(0, 0).get_most_recent_primitive.rawValue}"
puts

#Extra Tests
exp1 = VexAST::Exponentiation.new(int5, int2)
milestone_grid.set_cell(0, 0, exp1)
puts "Serialize result = #{milestone_grid.get_cell(0, 0).get_string_rep}"
puts "Result of 5^2; Expected: 25, Actual: #{milestone_grid.get_cell(0, 0).get_most_recent_primitive.rawValue}"
puts

cellLValue1 = VexAST::CellLValue.new(mod1, int5)
milestone_grid.set_cell(0, 0, cellLValue1)
puts "Serialize result = #{milestone_grid.get_cell(0, 0).get_string_rep}"
puts "Result of CellLValue; Expected: (7, 5), Actual: (#{milestone_grid.get_cell(0, 0).get_most_recent_primitive.rowVal}, #{milestone_grid.get_cell(0,0).get_most_recent_primitive.colVal})"
puts

less_equal1 = VexAST::LessOrEqualTo.new(int5, int5)
milestone_grid.set_cell(0, 0, less_equal1)
puts "Serialize result = #{milestone_grid.get_cell(0, 0).get_string_rep}"
puts "Result of 5 <= 5; Expected: true, Actual: #{milestone_grid.get_cell(0, 0).get_most_recent_primitive.rawValue}"
puts

float1 = VexAST::Float.new(9.353)
float_to_int1 = VexAST::FloatToInt.new(float1)
milestone_grid.set_cell(0, 0, float_to_int1)
puts "Serialize result = #{milestone_grid.get_cell(0, 0).get_string_rep}"
puts "Result of int(9.353); Expected: 9, Actual: #{milestone_grid.get_cell(0, 0).get_most_recent_primitive.rawValue}"
puts

int_to_float1 = VexAST::IntToFloat.new(int5)
milestone_grid.set_cell(0, 0, int_to_float1)
puts "Serialize result = #{milestone_grid.get_cell(0, 0).get_string_rep}"
puts "Result of float(5); Expected: 5.0, Actual: #{milestone_grid.get_cell(0, 0).get_most_recent_primitive.rawValue}"
puts

div1 = VexAST::Divide.new(float1, int5)
milestone_grid.set_cell(0, 0, div1)
puts "Serialize result = #{milestone_grid.get_cell(0, 0).get_string_rep}"
puts "Result of 9.353 / 5; Expected: 1.8706, Actual: #{milestone_grid.get_cell(0, 0).get_most_recent_primitive.rawValue}"
puts

#Typecheck Failure
true_boolean = VexAST::Boolean.new(true)
int15 = VexAST::Integer.new(15)
cell_r_val6 = VexAST::CellRValue.new(true_boolean, int15)
milestone_grid.set_cell(0, 0, cell_r_val6)


