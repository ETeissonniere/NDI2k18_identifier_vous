sdk = require './sdk'

handleLogin = (idUser) ->
	console.log "#{idUser} logged in, handle that!"

app = sdk handleLogin
app.listen 9999, () ->
	console.log 'Listening...'