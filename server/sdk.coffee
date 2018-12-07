express = require 'express'
contract = require '../chain/chain_client'

uniqueId = (length) ->
	id = ""
	id += Math.random().toString(36).substr(2) while id.length < length
	id.substr 0, length

module.exports = (callback, length=64) ->
	app = express()
	app.get '/api_ID/', (req, res) ->
		uID = uniqueId(length)

		# Start monitoring chain or exit
		contract().streamRandomId uID, callback

		res.status 202
		res.end uID

	return app