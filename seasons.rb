require 'rubygems'
require 'sinatra'
require 'geocoder'
require 'json'

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

	get '/' do
		if request.ip.to_s == '127.0.0.1'
			@state = 'California'
		else
			@state = request.location.state #based on IP, via geocoder
		end
		@month = Date::MONTHNAMES[Date.today.month] #month name
		day = Date.today.day
		if day >15
			timing = "late"
		else
			timing = "early"
		end
		key = @month+'-'+timing

		month_info = ingredient_by_month_and_state[key]

		puts "State: "+@state
		puts "Key: "+key

		if month_info.has_key?(@state)
			@ingredients = month_info[@state].join(", ")
		elsif month_info.has_key?(@state+" (Northern)")
			@ingredients = month_info[@state+" (Northern)"].join(", ")
		else
			@ingredients = "sorry no info"
		end

		puts "Ingredients: "+@ingredients

		erb :index
	end
