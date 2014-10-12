require 'rubygems'
require 'sinatra'
require "sinatra/config_file"
require 'geocoder'
require 'json'
require 'Date'
require_relative 'seasonal_ingredients'
require_relative 'flickr'

config_file 'config.yml'

def current_month
	month = Date::MONTHNAMES[Date.today.month] #month name
	day = Date.today.day
	earlylate = day > 15 ? "Late" : "Early"
	timing = partofmonth(month, earlylate)
	[timing, month, earlylate]
end

def partofmonth (month, earlylate)
	month+"-"+earlylate.downcase
end

ingredient_by_month_and_state = JSON.parse(IO.read("./seasons.json"))
@@seasonal_ingredients = SeasonalIngredients.new(ingredient_by_month_and_state)
@@flickr = Flickr.new(settings.flickr_key, settings.flickr_secret)

#Routes with most specific first
get '/:state/:month/:earlylate' do
	@state = params[:state]
	@earlylate = params[:earlylate]
	@month = partofmonth(params[:month], @earlylate)
	ingredients = @@seasonal_ingredients.for_month_and_state(@month, @state)
	@photos = @@flickr.discover(ingredients)
	@ingred_list =ingredients.join(", ")
	erb :index
end

get '/:state/:month' do
	@state = params[:state]
	@month = params[:month]
	ingredients = @@seasonal_ingredients.for_month_and_state(@month, @state)
	@photos = @@flickr.discover(ingredients)
	@ingred_list =ingredients.join(", ")
	erb :index
end

get '/' do
	(timing, month, earlylate) = current_month
	state = request.location.state.empty? ? 'California' : request.location.state
	redirect to('/'+state+'/'+month+'/'+earlylate)
end
