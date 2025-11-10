require_relative 'variable_runtime.rb'

class Cell
    attr_reader :held_AST
    attr_reader :string_rep
    attr_reader :most_recent_primitive
    attr_reader :variable_runtime
    
    #Create the cell; each cell gets its own variable runtime for storing variables and their values.
    def initialize()
        @variable_runtime = VariableRuntime.new()
    end

    #Get the AST held in the cell from its last evaluation.
    def get_held_AST()
        @held_AST  
    end

    #Set the AST held in the cell.
    def set_held_AST(held_AST)
        @held_AST = held_AST  
    end

    #Get the string representation of the AST in the cell.
    def get_string_rep()
        @string_rep  
    end

    #Set the string representation of the AST in the cell.
    def set_string_rep(string_rep)
        @string_rep = string_rep  
    end

    #Get the most recent primitive held in the cell, which will be set when the cell's value is assigned/reassigned.
    def get_most_recent_primitive()
        @most_recent_primitive  
    end

    #Set the most recent primitive held in the cell, which will be set when the cell's value is assigned/reassigned.
    def set_most_recent_primitive(most_recent_primitive)
        @most_recent_primitive = most_recent_primitive  
    end

    #Get the variable with the matching key from the cell.
    def get_variable(key)
        @variable_runtime.get_variable(key)
    end
    
    #Add a variable to this cell's variable array.
    def set_variable(key, value)
        @variable_runtime.add_variable(key, value)
    end
end