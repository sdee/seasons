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

ingredient_by_month_and_state = JSON.parse(IO.read("./seasons.json"))

helpers do
	def test
		Flickr.flickr_ingred_photo('arugula')
	end
end

def get_state (ip)
	@state = ip == '127.0.0.1' ? 'California' : @state = request.location.state #based on IP, via geocoder
end

def get_timing
	month = Date::MONTHNAMES[Date.today.month] #month name
	day = Date.today.day
	earlylate = day > 15 ? "Late" : "Early"
	timing = partofmonth(month, earlylate)
	return timing, month, earlylate
end

def north (state)
	state+" (Northern)"
end

def early (month)
	month+"-early"
end

def partofmonth (month, earlylate)
	month+"-"+earlylate.downcase
end

#Looks up ingredients by time and location.
#Takes in either a half month (early or late) or a month in which case we default to early part of the month
#Some states are divided into the Northern and Southern halves. For now, we default to the Northern half.
def get_seasonal_ingredients (timing, state, ingred_map)
	if ingred_map.has_key?(timing)
		ingreds_by_state = ingred_map[timing]
	else
		ingreds_by_state = ingred_map[early(timing)] #for months default to early
	end
	if ingreds_by_state.has_key?(state)
		ingredients = ingreds_by_state[state]
	elsif ingreds_by_state.has_key?(north(state))
		ingredients = ingreds_by_state [north(state)]
	else
		ingredients = "sorry no info"
	end
end

#Routes with most specific first
get '/:state/:month/:earlylate' do
	@state = params[:state]
	@month = params[:month]
	@earlylate = params[:earlylate]
	timing = partofmonth(@month, @earlylate)
	@ingredients = get_seasonal_ingredients(timing, @state, ingredient_by_month_and_state)
	erb :index
end

get '/:state/:month' do
	@state = params[:state]
	@month = params[:month]
	@ingredients = get_seasonal_ingredients(@month, @state, ingredient_by_month_and_state)
	erb :index
end

get '/' do
	state = get_state(request.ip.to_s)
	timing, month, earlylate = get_timing
	# @ingredients = get_seasonal_ingredients(@timing, @state, ingredient_by_month_and_state)
	# erb :index
	redirect to('/'+state+'/'+month+'/'+earlylate)
end
