require 'sinatra'
require 'open-uri'
require 'json'

set :port, 2334

API = "http://localhost:4567/"

def network_elements
  JSON.parse open(API).read
end

def oids(ne)
  JSON.parse open(API + ne).read
end

def values(ne, oid)
  JSON.parse open(API + ne + "/" + oid).read
end

def latest_value(ne, oid)
  JSON.parse open(API + ne + "/" + oid + "/latest").read
end

get '/' do
  erb :index, :locals => {network_elements: network_elements}
end

get '/:ne' do
  erb :network_element, :locals => {element: params[:ne], network_elements: network_elements, oids: oids(params[:ne])}
end

get '/:ne/:oid' do
  erb :oid, :locals => {element: params[:ne], variable: params[:oid], network_elements: network_elements, oids: oids(params[:ne]), rate: false}
end

get '/:ne/:oid/rate' do
  erb :oid, :locals => {element: params[:ne], variable: params[:oid], network_elements: network_elements, oids: oids(params[:ne]), rate: true}
end

get '/:ne/:oid/latest' do
  content_type :json
  latest_value(params[:ne], params[:oid]).to_json
end