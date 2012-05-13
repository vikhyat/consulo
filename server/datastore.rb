require 'thread'
require 'rdbi'
require 'rdbi-driver-sqlite3'
require 'msgpack'

class Datastore
  attr_reader :values
  
  def initialize
    @semaphore = Mutex.new
    @dbh = RDBI.connect(:SQLite3, :database => ":memory:")
    @values = []
  end
  
  def query(ne, oid)
    result = []
    tables.each do |table|
      r = @dbh.execute("SELECT timestamp,value FROM #{table} WHERE ne=#{ne.inspect} AND oid=#{oid.inspect};")
      result += r.fetch(:all)
    end
    result.map {|x| x[-1] = MessagePack.unpack(eval("\"#{x[-1]}\"")); x }.sort_by {|x| x[0] }
  end
  
  def save(values)
    values.each do |value|
      savev value
    end
  end
  
  def table_name(value)
    "data_for_#{Time.at(value[0]).strftime("%Y_%m_%d")}"
  end
  
  def tables
    result = @dbh.execute("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name;")
    result.fetch(:all).map {|x| x[0] }
  end
  
  def savev(value)
    @semaphore.synchronize do
      # get the table name
      name = table_name(value)
      # make sure the table exists
      @dbh.execute("CREATE TABLE IF NOT EXISTS #{name} (timestamp INTEGER, ne VARCHAR(15), oid VARCHAR(50), value VARCHAR(50));")
      # insert into table
      @dbh.execute("INSERT INTO #{name} (timestamp, ne, oid, value) VALUES (#{value[0]}, #{value[1].inspect}, #{value[2].inspect}, #{value[3].to_msgpack.inspect});")
    end
  end
end