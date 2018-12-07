MOCK_ID = "0x76278687267828"

module.exports = {
	streamRandomId: (token, callback) ->
		callback token, MOCK_ID
	,
	submitRandomId: (token) ->
		return true
	,
}