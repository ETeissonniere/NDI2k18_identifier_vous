express = require 'express'
contract = require '../chain/chain_client'

uniqueId = (length) ->
	id = ""
	id += Math.random().toString(36).substr(2) while id.length < length
	id.substr 0, length

module.exports = (length=64) ->
	app = express()
	app.get '/api_ID/', (req, res) ->
		uID = uniqueId(length)

		# Start monitoring chain or exit
		contract().streamRandomId uID, console.log

		res.status 202
		res.end uID

	return app