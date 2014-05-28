class Query
	constructor: ->
		@query = {}
	
	set: (query) ->
		_.extend @query, query
		Session.set "query", @query

@SearchQuery = new Query()