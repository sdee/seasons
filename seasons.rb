require 'sinatra'
require 'geocoder'


# Apricots, Arugula, Beets, Cherries , Garlic, Greens, Herbs, Lettuce, Onions , Peas, Radishes, Salad Greens, Spinach, Summer squash
ingredient_by_month = {'June' => {'San Francisco'=> ['apricots', 'arugula']}}

get '/' do 
	results = Geocoder.search("McCarren Park, Brooklyn, NY")
	r = results.first
	state = r.state
	month = Date::MONTHNAMES[Date.today.month]
	ingredient_by_month[month]['San Francisco'].join(", ")
	# request.location
end
