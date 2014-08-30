require 'rubygems'
require 'sinatra'
require 'geocoder'
require 'json'
require 'Date'

require_relative "flickr"

# include HTTParty

# ingredient_by_month_and_state = {'July' =>
# 								{'California' => ['Fennel' , 'Figs', 'Garlic', 'Green Garlic' , 'Herbs', 'Horseradish', 'Kale' , 'Kohlrabi', 'Leeks', 'Lemons', 'Lettuces' , 'Loquats', 'Melons', 'Mushrooms' , 'Mustard Greens', 'Nectarines', 'Nettles' , 'Okra', 'Olives', 'Onions', 'Oranges', 'Peaches', 'Peas', 'Peppers', 'Pistachioes', 'Plums', 'Pluots', 'Purslane' , 'Radicchio', 'Radish' , 'Rapini' , 'Raspberries', 'Rhubarb', 'Scallions', 'Shallots', 'Spinach', 'Strawberries',
# 									'Summer squash', 'Tayberries', 'Tomatillos', 'Tomatoes', 'Walnuts'],
# 									'Georgia' => ['Bell Pepper', 'Blueberries', 'Carrots', 'Cucumbers', 'Field Peas', 'Grapes', 'Greens', 'Melons', 'Peaches', 'Snap Beans', 'Sweet Corn', 'Tomatoes', 'Vidalia Onions', 'Yellow Squash', 'Zucchini']}
# 								}

ingredient_by_month_and_state = JSON.parse( IO.read("./seasons.json") )

helpers do
	def test
		Flickr.flickr_ingred_photo('arugula')
	end
end

def get_state (ip)
	@state = ip == '127.0.0.1' ? 'California' : @state = request.location.state #based on IP, via geocoder
end

def get_timing ()
	month = Date::MONTHNAMES[Date.today.month] #month name
	day = Date.today.day
	timing = day > 15 ? "late" : "early"
	timing = month+'-'+timing
	return timing, month
end

def get_seasonal_ingredients (timing, state, ingredient_by_month_and_state)
	month_info = ingredient_by_month_and_state[timing]
	if month_info.has_key?(state)
		ingredients = month_info[state]
		#default to northern for states with northern and southern
	elsif month_info.has_key?(state+" (Northern)")
		ingredients = month_info[state+" (Northern)"]
	else
		ingredients = "sorry no info"
	end
	ingredients.join(", ")
end

get '/' do
	@state = get_state(request.ip.to_s)
	@timing, @month = get_timing
	@ingredients = get_seasonal_ingredients(@timing, @state, ingredient_by_month_and_state)
	erb :index
end

get '/:state/:month' do
	@state = params[:state]
	@month = params[:month]
	@timing = @month+'-'+"early"
	@ingredients = get_seasonal_ingredients(@timing, @state, ingredient_by_month_and_state)
	erb :index
end
