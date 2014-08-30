require 'httparty'
class Flickr
  include HTTParty

	base_uri 'http://api.flickr.com'
	API_KEY = '17099a6369aa0e382f89766135fb1430'
	def self.flickr_ingred_photo(ingred_name)

	# http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=17099a6369aa0e382f89766135fb1430&tags=arugula&format=rest
		get("/services/rest/",
			:query => {
				:method => "flickr.photos.search",
				:api_key => "17099a6369aa0e382f89766135fb1430",
				:tags => ingred_name
			}
		)
	end
end
