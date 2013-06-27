require 'httparty'
class Flickr 
  include HTTParty

	base_uri 'http://api.flickr.com'
	API_KEY = '17099a6369aa0e382f89766135fb1430'
	def self.flickr_ingred_photo(ingred_name)

	    # get("/services/rest/", :query => {
	    #   :method => "flickr.photosets.getPhotos",
	    #   :api_key => API_KEY,
	    #   :photoset_id => PHOTOSET,
	    #   :per_page => per_page,
	    #   :page=> page,
	    #  })

	# http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=17099a6369aa0e382f89766135fb1430&tags=arugula&format=rest		
		get("/services/rest/", 
			:query => {
				:method => "flickr.photos.search",
				:api_key => "17099a6369aa0e382f89766135fb1430",
				:tags => ingred_name
			}
		)
	#HTTParty.get("http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=17099a6369aa0e382f89766135fb1430&tags=arugula")
	'blah'
	end
end
