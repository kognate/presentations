var redis = require("redis")
var openwhisk = require("openwhisk")

function main(params) {

  const client = redis.createClient({url: params.redis_url});
  return new Promise((resolve, reject) => {
    
    client.get(params.query, (err, cached_result) => {
      if (cached_result) {
	resolve(JSON.parse(cached_result));
      } else {
	const ow = openwhisk();
	const name = 'datalayersearch';
	const blocking = true, result = true;
	ow.actions.invoke({name, blocking, result, params}).then(result => {
	  client.set(params.query, JSON.stringify(result.response.result), 'EX', 600);
	  resolve(result.response.result);
	})	
      }
    });
  });
}
