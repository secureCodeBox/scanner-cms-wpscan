require 'sinatra'
require 'json'
require 'bundler'
Bundler.setup(:default)
require 'ruby-scanner-scaffolding'
require 'ruby-scanner-scaffolding/healthcheck'
require_relative "./wordpress_worker"

set :port, 8080
set :bind, '0.0.0.0'
set :environment, :production

client = WordpressWorker.new(
	'http://localhost:8080',
	'wordpress_webserverscan',
	['PROCESS_TARGETS']
)

get '/status' do
  Healthcheck.new(client)
end
