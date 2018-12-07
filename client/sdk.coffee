request = require 'superagent'

module.exports = (host) ->
	return {
		askRandomID: () ->
			try
				res = await request.get host + '/api_ID/'

				if res.status == 202
					return res.text
			catch e
				console.log e
			
	}