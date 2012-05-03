require 'yaml'
require_relative 'ldc.rb'
require_relative 'datastore.rb'

# load configuration
CONFIG = YAML.load File.read('conf.yaml')

# initialize global variables
$ldcs = []
CONFIG['ldcs'].each do |ldc_id|
  $ldcs.push LDC.new(ldc_id)
end

# shutdown procedure
trap "INT" do
  $ldcs.each {|ldc| ldc.deactivate }
end

$data = Datastore.new

require_relative 'worker.rb'

require 'sinatra'
require_relative 'api.rb'

# "04027626160"