ENV['RACK_ENV'] = 'test'

require './seasons.rb'
require 'rack/test'
require 'minitest/autorun'

class SeasonsTests < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  # def test_base_route
  #   browser = Rack::Test::Session.new(Rack::MockSession.new(Sinatra::Application))
  #   browser.get '/'
  #   # assert browser.last_response.ok?
  #   assert_redirected_to '/California/August'
  # end

  def test_restful_route
    browser = Rack::Test::Session.new(Rack::MockSession.new(Sinatra::Application))
    browser.get '/California/August'
    assert browser.last_response.ok?
    browser.get '/California/August/Late'
    assert browser.last_response.ok?
    assert browser.last_response.body.include?('California')
    assert browser.last_response.body.include?('August')
  end



end
