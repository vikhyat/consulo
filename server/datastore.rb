class Datastore
  attr_reader :values
  
  def initialize
    @values = []
  end
  
  def query(ne, oid)
    @values.select {|x| x[1] == ne and x[2] == oid }.map {|x| [x[0], x[3]] }.sort_by {|x| x[0] }
  end
  
  def save(values)
    @values += values
  end
end