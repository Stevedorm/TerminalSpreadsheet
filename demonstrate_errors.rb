require_relative 'lexer.rb'
require_relative 'parser.rb'
require_relative 'vex_ast.rb'
require_relative 'evaluate.rb'
require_relative 'serialize.rb'
require_relative 'grid.rb'
require_relative 'runtime.rb'

# Error: Unmatched left parenthesis
error_lex = Lexer.new("5 + (4 + (3)")
error_parse = Parser.new(error_lex.tokens)
#error_parse.parse_top_level()

# Error: No second operator for operation (&)
error_lex = Lexer.new("5 + 3 * 2 &")
error_parse = Parser.new(error_lex.tokens)
#error_parse.parse_top_level()

#Error: Unmatched right parenthesis
error_lex = Lexer.new("5 * 2 + 3)")
error_parse = Parser.new(error_lex.tokens)
#error_parse.parse_top_level()

#Error: Missing parenthesis for function call
error_lex = Lexer.new("max[0,0], [0, 1])")
error_parse = Parser.new(error_lex.tokens)
#error_parse.parse_top_level()

#Error: Missing left parenthesis for to float
error_lex = Lexer.new("float9)")
error_parse = Parser.new(error_lex.tokens)
#error_parse.parse_top_level()

#Error: Missing right parenthesis for to float
error_lex = Lexer.new("float(9")
error_parse = Parser.new(error_lex.tokens)
#error_parse.parse_top_level()

#Error: Missing bracket for function call
error_lex = Lexer.new("max([0,0], [0, 1])")
error_parse = Parser.new(error_lex.tokens)
#error_parse.parse_top_level()

#Error: Missing comma for function call
error_lex = Lexer.new("max([00], [0, 1])")
error_parse = Parser.new(error_lex.tokens)
#error_parse.parse_top_level()

#Error: Missing bracket for function call
error_lex = Lexer.new("max([0,0, [0, 1])")
error_parse = Parser.new(error_lex.tokens)
error_parse.parse_top_level()

#Error: Missing comma for function call
error_lex = Lexer.new("max([0,0] [0, 1])")
error_parse = Parser.new(error_lex.tokens)
#error_parse.parse_top_level()

#Error: Missing bracket for function call
error_lex = Lexer.new("max([0,0], 0, 1])")
error_parse = Parser.new(error_lex.tokens)
#error_parse.parse_top_level()

#Error: Missing comma for function call
error_lex = Lexer.new("max([0,0], [0 1])")
error_parse = Parser.new(error_lex.tokens)
#error_parse.parse_top_level()

#Error: Missing bracket for function call
error_lex = Lexer.new("max([0,0], [0, 1)")
error_parse = Parser.new(error_lex.tokens)
#error_parse.parse_top_level()

#Error: Missing parenthesis for function call
error_lex = Lexer.new("max([0,0], [0, 1]")
error_parse = Parser.new(error_lex.tokens)
#error_parse.parse_top_level()

#Error: Missing bracket for cellRValue
error_lex = Lexer.new("#0, 0]")
error_parse = Parser.new(error_lex.tokens)
#error_parse.parse_top_level()

#Error: Missing comma for cellRValue
error_lex = Lexer.new("#[0 0]")
error_parse = Parser.new(error_lex.tokens)
#error_parse.parse_top_level()

#Error: Missing bracket for cellRValue
error_lex = Lexer.new("#[0, 0")
error_parse = Parser.new(error_lex.tokens)
#error_parse.parse_top_level()

#Error: Missing bracket for cellLValue
error_lex = Lexer.new("0, 0]")
error_parse = Parser.new(error_lex.tokens)
#error_parse.parse_top_level()

#Error: Missing comma for cellLValue
error_lex = Lexer.new("[0 0]")
error_parse = Parser.new(error_lex.tokens)
#error_parse.parse_top_level()

#Error: Missing bracket for cellLValue
error_lex = Lexer.new("[0, 0")
error_parse = Parser.new(error_lex.tokens)
#error_parse.parse_top_level()


