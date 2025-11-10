class Runtime

  attr_reader :runtime_grid

  #Initialize the runtime (add the grid to the runtime).
  def initialize(runtime_grid)
    @runtime_grid = runtime_grid
  end

  #Get the grid associated with this runtime.
  def get_grid()
    @runtime_grid
  end
    
end