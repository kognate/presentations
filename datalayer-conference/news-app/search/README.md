This is an openwhisk action to run a query against 
a Watson Discovery News Service environment.

This is a docker action that can be found at
[kognate/datalayer-search](https://hub.docker.com/r/kognate/datalayer-search/)

You can create this action in your own OpenWhisk environment using:

`wsk action create datalayersearch --docker kognate/datalayer-search`

This action requires the following parameters:

  * `username` : this is the username for your Watson Discovery instance
  * `password` : this is the password for your Watson Discovery instance
  * `news_environment_id`: the environment ID for the environment to query
  * `news_collection_id`: the collection ID of the collection to query
  * `query` : the NLU query 
