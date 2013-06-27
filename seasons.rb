require 'rubygems'
require 'sinatra'
require 'geocoder'
require_relative "flickr"

# include HTTParty

	ingredient_by_month_and_state = {'June' => 
									{'California' => ['Fennel' , 'Figs', 'Garlic', 'Green Garlic' , 'Herbs', 'Horseradish', 'Kale' , 'Kohlrabi', 'Leeks', 'Lemons', 'Lettuces' , 'Loquats', 'Melons', 'Mushrooms' , 'Mustard Greens', 'Nectarines', 'Nettles' , 'Okra', 'Olives', 'Onions', 'Oranges', 'Peaches', 'Peas', 'Peppers', 'Pistachioes', 'Plums', 'Pluots', 'Purslane' , 'Radicchio', 'Radish' , 'Rapini' , 'Raspberries', 'Rhubarb', 'Scallions', 'Shallots', 'Spinach', 'Strawberries', 
										'Summer squash', 'Tayberries', 'Tomatillos', 'Tomatoes', 'Walnuts'],
										'Georgia' => ['Bell Pepper', 'Blueberries', 'Carrots', 'Cucumbers', 'Field Peas', 'Grapes', 'Greens', 'Melons', 'Peaches', 'Snap Beans', 'Sweet Corn', 'Tomatoes', 'Vidalia Onions', 'Yellow Squash', 'Zucchini']}
									}


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
		@ingredients = ingredient_by_month_and_state[@month][@state].join(", ")
		@test = test
		#puts flickr_ingred_photo('arugula')
		erb :index
	end




