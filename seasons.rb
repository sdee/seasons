require 'rubygems'
require 'sinatra'
require 'geocoder'

# Apricots, Arugula, Beets, Cherries , Garlic, Greens, Herbs, Lettuce, Onions , Peas, Radishes, Salad Greens, Spinach, Summer squash
ingredient_by_month = {'June' => {'California'=> ['apricots', 'arugula']}}

get '/' do 
	state = r.request.location.state.to_s
	month = Date::MONTHNAMES[Date.today.month]
	ingredient_by_month[month][state].join(", ")
end
