require 'json'

get '/' do
  CONFIG['network_elements'].keys.to_json
end

get '/:ne' do
  oids = CONFIG['network_elements'][params[:ne]].to_json
end

get '/:ne/:oid' do
  $data.query(params[:ne], params[:oid]).to_json
end

get '/:ne/:oid/latest' do
  $data.query(params[:ne], params[:oid]).max {|x| x[0] }.to_json
end