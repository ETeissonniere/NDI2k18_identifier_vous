express = require 'express'

uniqueId = (length) ->
	id = ""
	id += Math.random().toString(36).substr(2) while id.length < length
	id.substr 0, length

module.exports = (length=64) ->
	app = express()
	app.get '/api_ID/', (req, res) ->
		uID = uniqueId(length)

		res.status 202
		res.end uID

	return app