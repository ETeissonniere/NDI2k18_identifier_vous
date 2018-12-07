Web3 = require 'web3'
web3 = new Web3(new Web3.providers.WebsocketProvider('wss://ropsten.infura.io/ws'))

sdk = require './sdk'
contract = require '../chain/chain_client'

SERVER = '127.0.0.1:9999'

# Could be an "identity"
PUBLIC_KEY = '0xCC18705aA3dC7387909bc5B9a60E2b472c90F970'
PRIVATE_KEY = 'd2ddbdae60a8ea310bae3f6a31a10b7cc39bd4b1c536f206f674d03b2d1d68b8'

client = sdk SERVER

submit = (id) ->
	console.log "Submitting #{web3.utils.sha3 id}"
	await contract().submitRandomId id, PRIVATE_KEY, PUBLIC_KEY

doExample = () ->
	id = await client.askRandomID()
	await submit id

	process.exit 0


doExample()