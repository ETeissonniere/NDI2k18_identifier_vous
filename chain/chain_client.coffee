Web3 = require 'web3'
web3 = new Web3(new Web3.providers.WebsocketProvider('wss://ropsten.infura.io/ws'))

fs = require 'fs'

ABI_FILE = './chain/identity_manager.abi.json'
MOCK_ID = '0x76278687267828'
CONTRACT_ADDR = '0xCC18705aA3dC7387909bc5B9a60E2b472c90F970'

buildStreamRandomId = (contract) ->
	return (token, callback) ->
		hashToken = web3.utils.sha3 token
		console.log token, hashToken
		contract.once 'GotNewRandomID', {filter: {randomID: hashToken}}, (error, event) ->
			callback event.returnValues.identity

buildSubmitRandomId = (contract) -> 
	return (token, privateKey, addr) ->
		hashed = web3.utils.sha3 token
		data = contract.methods.submitRandomID(hashed).encodeABI()
		

		tx = {
			to: CONTRACT_ADDR,
			from: addr,
			data: data,
			gas: 4576781,
			gasLimit: 25760,
			gasPrice: await web3.eth.getGasPrice(),
			nonce: await web3.eth.getTransactionCount(addr),
		}

		console.log tx
		txSigned = await web3.eth.accounts.signTransaction tx, privateKey 
		# Send tx to chain
		web3.eth.sendSignedTransaction txSigned.rawTransaction

module.exports = () ->
	abi = fs.readFileSync ABI_FILE, 'utf-8'
	contract = new web3.eth.Contract(JSON.parse abi)
	contract.options.address = CONTRACT_ADDR

	return {
		streamRandomId: buildStreamRandomId(contract),
		submitRandomId: buildSubmitRandomId(contract)
	}