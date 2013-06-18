require 'rubygems'
require 'bundler'
Bundler.require

require './seasons.rb'
run Sinatra::Application
