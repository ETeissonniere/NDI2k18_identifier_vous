Web3 = require 'web3'
web3 = new Web3(new Web3.providers.WebsocketProvider('wss://ropsten.infura.io/ws'))

fs = require 'fs'

ABI_FILE = './chain/identity_manager.abi.json'
MOCK_ID = '0x76278687267828'
CONTRACT_ADDR = '0xCC18705aA3dC7387909bc5B9a60E2b472c90F970'

module.exports = () ->
	abi = fs.readFileSync ABI_FILE, 'utf-8'
	contract = new web3.eth.Contract(JSON.parse abi)
	contract.options.address = CONTRACT_ADDR

	return {
		streamRandomId: (token, callback) ->
			hashToken = web3.utils.sha3 token
			console.log hashToken
			contract.once 'GotNewRandomID', {filter: {randomID: hashToken}}, (error, event) ->
				callback event.returnValues.identity
		,
		submitRandomId: (token) ->
			return true
		,
	}