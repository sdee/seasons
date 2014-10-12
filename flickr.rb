require 'flickraw'
require "sinatra/config_file"

class Flickr

  def initialize(api_key, secret)
    FlickRaw.api_key=api_key
    FlickRaw.shared_secret=secret
  end

  def top_image(ingredient)
    puts "ingred! "+ingredient
    args = {}
    args['text'] = ingredient+' farmers market'
    photos = flickr.photos.search args
    print photos
    FlickRaw.url photos[0]
  end

  def discover(ingredients)
    ingredients.sample(9).map{|i| [i, top_image(i)]}
  end

end
