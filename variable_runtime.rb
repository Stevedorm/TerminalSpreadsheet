class VariableRuntime

  attr_accessor :variable_store

  def initialize()
    @variable_store = Hash.new
  end

  def add_variable(key, value)
    @variable_store[key] = value
  end

  def get_variable(key)
    @variable_store[key]
  end
end