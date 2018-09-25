from openwhisk_docker_action import Action
from watson_developer_cloud import DiscoveryV1
import json

app = Action('News Query')


def filter(resultsdict):
    stories = []
    for item in resultsdict["results"]:
        headline = item["title"]
        stories.append({"url": item["url"], "headline": headline, "yyyymmdd": item["yyyymmdd"]})

    filtered = {}
    filtered["count"] = resultsdict["matching_results"]
    filtered["stories"] = stories
    if "aggregations" in resultsdict:
        filtered["aggregations"] = resultsdict["aggregations"]

    return filtered

@app.main
def main(params):
    query_params = params

    if "value" in params:
        query_params = params["value"]

    if "username" in query_params and "password" in query_params:
        discovery = DiscoveryV1("2016-12-31",
                                username=query_params["username"],
                                password=query_params["password"])

        queryparams = {"natural_language_query": query_params["query"], "sort": "-yyyymmdd"}

        if "filter" in query_params:
            queryparams["filter"] = query_params["filter"]

        if "aggregations" in query_params:
            queryparams["aggregations"] = query_params["aggregations"]

        results = None
        if "stub" in query_params and query_params["stub"] == 1:
            stubfile = open("stub.json")
            results = json.loads(stubfile.read())
        else:
            results = discovery.query(query_params["news_environment_id"],
                                      query_params["news_collection_id"],
                                      queryparams)
        if "verbose" in query_params:
            return results
        else:
            return filter(results)
    else:
        return params