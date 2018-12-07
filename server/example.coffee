sdk = require './sdk'

app = sdk()
app.listen 9999, () ->
	console.log 'Listening...'