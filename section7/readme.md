``` 
#Specifying the result format
#Returning results as YAML
GET /recipes/_search?format=yaml
{
    "query": {
      "match": { "title": "pasta" }
    }
}
#Returning pretty JSON
GET /recipes/_search?pretty
{
    "query": {
      "match": { "title": "pasta" }
    }
}


#Source filtering
#Excluding the _source field altogether
GET /recipes/_search
{
  "_source": false,
  "query": {
    "match": { "title": "pasta" }
  }
}
#Only returning the created field
GET /recipes/_search
{
  "_source": "created",
  "query": {
    "match": { "title": "pasta" }
  }
}
#Only returning an object's key
GET /recipes/_search
{
  "_source": "ingredients.name",
  "query": {
    "match": { "title": "pasta" }
  }
}
#Returning all of an object's keys
GET /recipes/_search
{
  "_source": "ingredients.*",
  "query": {
    "match": { "title": "pasta" }
  }
}
#Returning the ingredients object with all keys, and the servings field
GET /recipes/_search
{
  "_source": [ "ingredients.*", "servings" ],
  "query": {
    "match": { "title": "pasta" }
  }
}
#Including all of the ingredients object's keys, except the name key
GET /recipes/_search
{
  "_source": {
    "includes": "ingredients.*",
    "excludes": "ingredients.name"
  },
  "query": {
    "match": { "title": "pasta" }
  }
}

#Using a query parameter
GET /products/_search?size=2

GET /products/_search?size=2
{
  "_source": false,
  "query": {
    "match": {
      "title": "pasta"
    }
  }
}
#Using a parameter within the request body
GET /recipes/_search
{
  "_source": false,
  "size": 2,
  "query": {
    "match": {
      "title": "pasta"
    }
  }
}


#Specifying an offset with the from parameter
GET /recipes/_search
{
  "_source": false,
  "size": 2,
  "from": 2,
  "query": {
    "match": {
      "title": "pasta"
    }
  }
}


#Sorting results
#Sorting by ascending order (implicitly)
GET /recipes/_search
{
  "_source": false,
  "query": {
    "match_all": {}
  },
  "sort": [
    "preparation_time_minutes"
  ]
}
#Sorting by descending order
GET /products/_search?size=2
{
  "_source": "created",
  "query": {
    "match_all": {}
  },
  "sort": [
    { "created": "desc" }
  ]
}
#Sorting by multiple fields
GET /recipes/_search
{
  "_source": [ "preparation_time_minutes", "created" ],
  "query": {
    "match_all": {}
  },
  "sort": [
    { "preparation_time_minutes": "asc" },
    { "created": "desc" }
  ]
}

#Sorting by multi-value fields
#Sorting by the average rating (descending)
GET /recipes/_search
{
  "_source": "ratings",
  "query": {
    "match_all": {}
  },
  "sort": [
    {
      "ratings": {
        "order": "desc",
        "mode": "avg"
      }
    }
  ]
}

# Queries can be run in 2 context
# Query context
# Filter context
#Filters
#Adding a filter clause to the bool query
GET /recipes/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "title": "pasta"
          }
        }
      ],
      "filter": [
        {
          "range": {
            "preparation_time_minutes": {
              "lte": 15
            }
          }
        }
      ]
    }
  }
}
```