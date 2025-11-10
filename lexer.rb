require_relative 'token.rb'

class Lexer

  OPERATORS = ['+', '-', '*', '/', '%']
  COMPARISON = ['<', '>', '=', '!']
  LOGIC_BITWISE = ['&', '|', '~', '^']

  attr_accessor :input_str
  attr_accessor :tokens
  attr_accessor :current_token
  attr_accessor :cur_ind

  #Initialize the lexer with the string we want lexed. The string will automatically be lexed.
  def initialize(input_str)
    @input_str = input_str
    @tokens = Array.new
    lex()
  end

  #Lex the input.
  def lex()
    @current_token = Array.new
    @cur_ind = 0
    start_ind = @cur_ind
    while @cur_ind < @input_str.length
      if has(" ") # Skip spaces
        @cur_ind = @cur_ind + 1
      
      elsif has("(") # Left Paren
        start_ind = @cur_ind
        capture()
        emit_token(:left_paren, start_ind, @cur_ind)
      
      elsif has(")") # Right Paren
        start_ind = @cur_ind
        capture()
        emit_token(:right_paren, start_ind, @cur_ind) 

      elsif has_operator() # Operator
        start_ind = @cur_ind
        lex_operator(start_ind)

      elsif has_comparison() # Comparison
        start_ind = @cur_ind
        lex_comparison(start_ind)
      
      elsif has_logic_bitwise() #logical and bitwise
        start_ind = @cur_ind
        lex_logic_bitwise(start_ind)

      elsif has_numeric() #Numeric tokenization
        start_ind = @cur_ind
        capture()
        lex_numeric(start_ind)

      elsif has("\"") # String tokenization
        start_ind = @cur_ind
        capture()
        lex_string(start_ind)
      
      elsif has_block()  # Block
        start_ind = @cur_ind
        capture()
        capture()
        capture()
        capture()
        capture()
        emit_token(:block, start_ind, @cur_ind)

      elsif has("#") # Cell Address/Hashtag
        start_ind = @cur_ind
        capture()
        emit_token(:hashtag, start_ind, @cur_ind)
      
      elsif has(",") # Commas
        start_ind = @cur_ind
        capture()
        emit_token(:comma, start_ind, @cur_ind)
      
      elsif has("[") # Left Bracket
        start_ind = @cur_ind
        capture()
        emit_token(:left_bracket, start_ind, @cur_ind)
      
      elsif has("]") # Right Bracket
        start_ind = @cur_ind
        capture()
        emit_token(:right_bracket, start_ind, @cur_ind)

      elsif has("{")
        start_ind = @cur_ind
        capture()
        emit_token(:left_curly_brace, start_ind, @cur_ind)

      elsif has("}")
        start_ind = @cur_ind
        capture()
        emit_token(:right_curly_brace, start_ind, @cur_ind)

      elsif has(".")
        start_ind = @cur_ind
        capture()
        if has(".") && @input_str[@cur_ind + 1] == "."
          capture()
          capture()
          emit_token(:exclusive_range, start_ind, @cur_ind)
        elsif has(".") && !@input_str[@cur_ind + 1] != "."
          capture()
          emit_token(:inclusive_range, start_ind, @cur_ind)
        else
          raise 'Lex Error: Bad range character'
        end

      elsif @input_str[@cur_ind] =~ /[A-Za-z]/
        start_ind = @cur_ind
        lex_functions(start_ind)
      
      elsif @input_str[@cur_ind] =~ /[ \t\n]/
        start_ind = @cur_ind
        capture()
        text = @current_token.join()
        type = case text
        when "\t"      then :tab
        when "\n"     then :newline
        else
          raise 'Lex Error: Bad whitespace character'
        end
        emit_token(type, start_ind, @cur_ind)

      else
        raise "Lexer error: Unable to lex input."
      end
    end
  end

  #Lex a string by taking out "
  def lex_string(start_ind)
    while @cur_ind < @input_str.length && !has("\"")
      capture()
    end
    if @cur_ind < @input_str.length && has("\"")
      capture()
      emit_token(:string, start_ind, @cur_ind)
    else
      raise "Lexing error: No closing quotation mark for string"
    end
  end

  #Lex a numeric (integer/float).
  def lex_numeric(start_ind)
    while @cur_ind < @input_str.length && has_numeric()
      capture()
    end
    if @cur_ind < @input_str.length && has(".")
      capture()
      while @cur_ind < @input_str.length && has_numeric()
        capture()
      end
      emit_token(:float, start_ind, @cur_ind)
    else
      emit_token(:int, start_ind, @cur_ind)
    end
  end

  #Lex an operator (+, -, *, /, %).
  def lex_operator(start_ind)
    if has("+")
      capture()
      emit_token(:plus, start_ind, @cur_ind)
    elsif has("-")
      capture()
      emit_token(:minus, start_ind, @cur_ind)
    elsif has("*")
      capture()
      if @cur_ind < @input_str.length && has("*")
        capture()
        emit_token(:exponent, start_ind, @cur_ind)
      else
        emit_token(:multiply, start_ind, @cur_ind)
      end
    elsif has("/")
      capture()
      emit_token(:slash, start_ind, @cur_ind)
    elsif has("%")
      capture()
      emit_token(:percent, start_ind, @cur_ind)
    else
      raise "Lexer error: Unable to lex input."
    end
  end

  #Lex a comparison (<, >, <=, >=, !=, ==).
  def lex_comparison(start_ind)
    if has("<") # Less/Less-Equal/LShift
      capture()
      if @cur_ind < @input_str.length && has("<") # LShift
        capture()
        emit_token(:lshift, start_ind, @cur_ind)
      elsif @cur_ind < @input_str.length && has("=") # Less-Equal
        capture()
        emit_token(:less_equal, start_ind, @cur_ind)
      else
        emit_token(:less_than, start_ind, @cur_ind)
      end
    elsif has(">") # Greater/Greater-Equal/RShift
      capture()
      if @cur_ind < @input_str.length && has(">") # RShift
        capture()
        emit_token(:rshift, start_ind, @cur_ind)
      elsif @cur_ind < @input_str.length && has("=") # Greater-Equal
        capture()
        emit_token(:greater_equal, start_ind, @cur_ind)
      else
        emit_token(:greater_than, start_ind, @cur_ind)
      end
    elsif has("=") # Equal-to
      capture()
      if @cur_ind < @input_str.length && has("=")
        capture()
        emit_token(:equal_to, start_ind, @cur_ind)
      else
        emit_token(:assignment_operator, start_ind, @cur_ind)
      end
    elsif has("!") # Logical-Not/Not-Equal
      capture()
      if @cur_ind < @input_str.length && has("=")
        capture()
        emit_token(:not_equal, start_ind, @cur_ind)
      else
        emit_token(:logical_not, start_ind, @cur_ind)
      end
    else
      raise "Lexer error: Unable to lex input."
    end
  end

  #Lex a bitwise operator (&, |, ^, ~).
  def lex_logic_bitwise(start_ind)
    if has("&") # And
      capture()
      if @cur_ind < @input_str.length && has("&")
        capture()
        emit_token(:logical_and, start_ind, @cur_ind)
      else
        emit_token(:bitwise_and, start_ind, @cur_ind)
      end
    elsif has("|") # Or
      capture()
      if @cur_ind < @input_str.length && has("|")
        capture()
        emit_token(:logical_or, start_ind, @cur_ind)
      else
        emit_token(:bitwise_or, start_ind, @cur_ind)
      end
    elsif has("^") # Xor
      capture()
      emit_token(:bitwise_xor, start_ind, @cur_ind)
    elsif has("~") # Not
      capture()
      emit_token(:bitwise_not, start_ind, @cur_ind)
    else
      raise "Lexer error: Unable to lex input."
    end
  end

  #Lex a function (max, min, mean, true, false, sum, if-else, for-each).
  def lex_functions(start_ind)
    while @cur_ind <= @input_str.length && @input_str[@cur_ind] =~ /[A-Za-z0-9]/ #undersore needed at the end?
      capture()
    end
      text = @current_token.join()
    
      type = case text
      when "true"      then :true
      when "false"     then :false
      when "sum"       then :sum
      when "min"       then :min
      when "max"       then :max
      when "mean"      then :mean
      when "int"       then :to_int
      when "float"     then :to_float
      when "if"      then :if
      when "else"       then :else
      when "end"     then :end
      when "for"      then :for
      when "in"       then :in
      else # variable handled here?
        :variable
      end
      emit_token(type, start_ind, @cur_ind)
  end

  def lex_conditional(start_ind)
  end

  #Check if the next token is of target type.
  def has(target)
    cur_char = @input_str[@cur_ind]
    if (cur_char == target)
      return true
    else
      return false
    end
  end

  #Check if we have a Block.
  def has_block()
    cur_pos = @cur_ind
    if cur_pos + 4 < @input_str.length
      maybe_block = @input_str[@cur_ind..]
      maybe_block.include?("Block")
    else
      false
    end
  end

  #Check if we have an operator.
  def has_operator()
    cur_char = @input_str[@cur_ind]
    OPERATORS.include?(cur_char)
  end

  #Check if we have a comparison
  def has_comparison()
    cur_char = @input_str[@cur_ind]
    COMPARISON.include?(cur_char)
  end

  #Check if we have a bitwise operation.
  def has_logic_bitwise()
    cur_char = @input_str[@cur_ind]
    LOGIC_BITWISE.include?(cur_char)
  end

  #Check if we have a numeric type.
  def has_numeric()
    @input_str[@cur_ind].to_i.to_s == @input_str[@cur_ind]
  end

  #Collect a character and add it to our current running token.
  def capture
    @current_token << @input_str[@cur_ind]
    @cur_ind = @cur_ind + 1
  end

  #Emit a token.
  def emit_token(type, start_ind, end_ind)
    @current_token = @current_token.join()
    token = Token.new(type, @current_token, start_ind, end_ind)
    @tokens << token
    @current_token = Array.new
  end
end