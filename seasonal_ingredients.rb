require 'geocoder'
require 'Date'

# ingredient_by_month_and_state = {'July' =>
# 								{'California' => ['Fennel' , 'Figs', 'Garlic', 'Green Garlic' , 'Herbs', 'Horseradish', 'Kale' , 'Kohlrabi', 'Leeks', 'Lemons', 'Lettuces' , 'Loquats', 'Melons', 'Mushrooms' , 'Mustard Greens', 'Nectarines', 'Nettles' , 'Okra', 'Olives', 'Onions', 'Oranges', 'Peaches', 'Peas', 'Peppers', 'Pistachioes', 'Plums', 'Pluots', 'Purslane' , 'Radicchio', 'Radish' , 'Rapini' , 'Raspberries', 'Rhubarb', 'Scallions', 'Shallots', 'Spinach', 'Strawberries',
# 									'Summer squash', 'Tayberries', 'Tomatillos', 'Tomatoes', 'Walnuts'],
# 									'Georgia' => ['Bell Pepper', 'Blueberries', 'Carrots', 'Cucumbers', 'Field Peas', 'Grapes', 'Greens', 'Melons', 'Peaches', 'Snap Beans', 'Sweet Corn', 'Tomatoes', 'Vidalia Onions', 'Yellow Squash', 'Zucchini']}
# 								}

class SeasonalIngredients

  attr_reader :ingred_map
  def initialize(ingredient_by_month_and_state)
    @ingred_map = ingredient_by_month_and_state
  end

  #Looks up ingredients by time and location.
  #Takes in either a half month (early or late) or a month in which case we default to early part of the month
  #Some states are divided into the Northern and Southern halves. For now, we default to the Northern half.
  def for_month_and_state (timing, state)
    ingreds_by_state = ingred_map[timing] || ingred_map[early(timing)] || {}
    ingredients = ingreds_by_state[state] || ingreds_by_state[north(state)] || ["sorry no info"]
    ingredients.join(", ")
  end

  def early (month)
    month+"-early"
  end

  def states
    ingred_map['July-late'].keys.map{|x| x.dup.sub(/\s\(.*\)/,'')}
  end

  def north (state)
    state+" (Northern)"
  end

end
