``` 
# can query from URL
# can query using keyword query (recommended way)

# search query
GET /products/_search
{
  "query":{
  "match_all":{}
    
  }
}


# term level query
# query are not analyzed
# Search for term
# Searching for terms
# Basic usage
GET /products/_search
{
  "query": {
    "term": {
      "tags.keyword": "Vegetable"
    }
  }
}
# Explicit syntax
# A more explicit syntax than the above. Use this if you need to add parameters to the query.

GET /products/_search
{
  "query": {
    "term": {
      "tags.keyword": {
        "value": "Vegetable"
      }
    }
  }
}
# Case insensitive search
GET /products/_search
{
  "query": {
    "term": {
      "tags.keyword": {
        "value": "Vegetable",
        "case_insensitive": true
      }
    }
  }
}
# Searching for multiple terms
GET /products/_search
{
  "query": {
    "terms": {
      "tags.keyword": ["Soup", "Meat"]
    }
  }
}
#Searching for booleans
GET /products/_search
{
  "query": {
    "term": {
      "is_active": true
    }
  }
}
# Searching for numbers
GET /products/_search
{
  "query": {
    "term": {
      "in_stock": 1
    }
  }
}
# Searching for dates
GET /products/_search
{
  "query": {
    "term": {
      "created": "2007/10/14"
    }
  }
}
# Searching for timestamps
GET /products/_search
{
  "query": {
    "term": {
      "created": "2007/10/14 12:34:56"
    }
  }
}

# Retrieving documents by IDs
GET /products/_search
{
  "query": {
    "ids": {
      "values": ["100", "200", "300"]
    }
  }
}

# Range searches
#Basic usage
GET /products/_search
{
  "query": {
    "range": {
      "in_stock": {
        "gte": 1,
        "lte": 5
      }
    }
  }
}
#SQL: SELECT * FROM products WHERE in_stock >= 1 AND in_stock <= 5

GET /products/_search
{
  "query": {
    "range": {
      "in_stock": {
        "gt": 1,
        "lt": 5
      }
    }
  }
}
#SQL: SELECT * FROM products WHERE in_stock > 1 AND in_stock < 5

#Querying dates
#Basic usage
GET /products/_search
{
  "query": {
    "range": {
      "created": {
        "gte": "2020/01/01",
        "lte": "2020/01/31"
      }
    }
  }
}
#Specifying the time
GET /products/_search
{
  "query": {
    "range": {
      "created": {
        "gte": "2020/01/01 00:00:00",
        "lte": "2020/01/31 23:59:59"
      }
    }
  }
}
#Specifying a UTC offset
GET /products/_search
{
  "query": {
    "range": {
      "created": {
        "time_zone": "+01:00",
        "gte": "2020/01/01 01:00:00",
        "lte": "2020/02/01 00:59:59"
      }
    }
  }
}
#Specifying a date format
GET /products/_search
{
  "query": {
    "range": {
      "created": {
        "format": "dd/MM/yyyy",
        "gte": "01/01/2020",
        "lte": "31/01/2020"
      }
    }
  }
}

# Prefixes, wildcards & regular expressions
#Searching for a prefix
GET /products/_search
{
  "query": {
    "prefix": {
      "name.keyword": {
        "value": "Past"
      }
    }
  }
}
#Wildcards
#Single character wildcard (?)
GET /products/_search
{
  "query": {
    "wildcard": {
      "tags.keyword": {
        "value": "Past?"
      }
    }
  }
}
#Zero or more characters wildcard (*)
GET /products/_search
{
  "query": {
    "wildcard": {
      "tags.keyword": {
        "value": "Bee*"
      }
    }
  }
}
#Regexp in between a t0 z or 1 to 9 etc
GET /products/_search
{
  "query": {
    "regexp": {
      "tags.keyword": {
        "value": "Bee(f|r)+"
      }
    }
  }
}
# insensitive searches
#All of the above queries can be made case insensitive by adding the case_insensitive parameter, e.g.:

GET /products/_search
{
  "query": {
    "prefix": {
      "name.keyword": {
        "value": "Past",
        "case_insensitive": true
      }
    }
  }
}

# Query by field existance
#Querying by field existence
#Basic usage
GET /products/_search
{
  "query": {
    "exists": {
      "field": "tags.keyword"
    }
  }
}
#SQL: SELECT * FROM products WHERE tags IS NOT NULL

#Inverting the query
#There is no dedicated query for this, so we do it with the bool query.

GET /products/_search
{
  "query": {
    "bool": {
      "must_not": [
        {
          "exists": {
            "field": "tags.keyword"
          }
        }
      ]
    }
  }
}
#SQL: SELECT * FROM products WHERE tags IS NULL

# The match query
#The match query
#Basic usage
GET /products/_search
{
  "query": {
    "match": {
      "name": "pasta"
    }
  }
}
#Full text queries are analyzed (and therefore case insensitive), so the below query yields the same results.

GET /products/_search
{
  "query": {
    "match": {
      "name": "PASTA"
    }
  }
}
#Searching for multiple terms
GET /products/_search
{
  "query": {
    "match": {
      "name": "PASTA CHICKEN"
    }
  }
}
#Specifying the operator
#Defaults to or. The below makes both terms required.

GET /products/_search
{
  "query": {
    "match": {
      "name": {
        "query": "pasta chicken",
        "operator": "and"
      }
    }
  }
}

#Searching multiple fields
#Basic usage
GET /products/_search
{
  "query": {
    "multi_match": {
      "query": "vegetable",
      "fields": ["name", "tags"]
    }
  }
}
#Per-field relevance boosting
GET /products/_search
{
  "query": {
    "multi_match": {
      "query": "vegetable",
      "fields": ["name^2", "tags"]
    }
  }
}
#Specifying a tie breaker
GET /products/_search
{
  "query": {
    "multi_match": {
      "query": "vegetable broth",
      "fields": ["name", "description"],
      "tie_breaker": 0.3
    }
  }
}

# the tie_breaker parameter is used to control the scoring of documents that have the same relevance scores. When multiple documents have the same score, Elasticsearch uses the tie_breaker to determine their final ranking in the search results.


# Phrase search
# a phrase search is used to find documents that contain an exact sequence of words in a specified order. 
#Phrase searches
#Basic usage
GET /products/_search
{
  "query": {
    "match_phrase": {
      "name": "mango juice"
    }
  }
}
#More examples
GET /products/_search
{
  "query": {
    "match_phrase": {
      "name": "juice mango"
    }
  }
}
GET /products/_search
{
  "query": {
    "match_phrase": {
      "name": "Juice (mango)"
    }
  }
}
GET /products/_search
{
  "query": {
    "match_phrase": {
      "description": "browse the internet"
    }
  }
}

# Leaf queries are simple queries that operate on a single field. They don't contain other queries within them and are used to match specific terms or conditions. 
#- Match Query:
#- Term Query
#- Range Query:

# Compound queries are queries that can contain other queries, allowing for the combination of multiple conditions. These queries are used to express complex search requirements. 
#- Bool 
#- Dis Max Query:



# Querying with boolean logic
#must
#Query clauses added within the must occurrence type are required to match.

GET /products/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "term": {
            "tags.keyword": "Alcohol"
          }
        }
      ]
    }
  }
}
#SQL: SELECT * FROM products  WHERE tags IN ("Alcohol")

#must_not
#Query clauses added within the must_not occurrence type are required to not match.

GET /products/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "term": {
            "tags.keyword": "Alcohol"
          }
        }
      ],
      "must_not": [
        {
          "term": {
            "tags.keyword": "Wine"
          }
        }
      ]
    }
  }
}
#SQL: SELECT * FROM products WHERE tags IN ("Alcohol") AND tags NOT IN ("Wine")

#should
#Matching query clauses within the should occurrence type boost a matching document's relevance score.

GET /products/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "term": {
            "tags.keyword": "Alcohol"
          }
        }
      ],
      "must_not": [
        {
          "term": {
            "tags.keyword": "Wine"
          }
        }
      ],
      "should": [
        {
          "term": {
            "tags.keyword": "Beer"
          }
        }
      ]
    }
  }
}
#An example with a few more adding more should query clauses:

GET /products/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "term": {
            "tags.keyword": "Alcohol"
          }
        }
      ],
      "must_not": [
        {
          "term": {
            "tags.keyword": "Wine"
          }
        }
      ],
      "should": [
        {
          "term": {
            "tags.keyword": "Beer"
          }
        },
        {
          "match": {
            "name": "beer"
          }
        },
        {
          "match": {
            "description": "beer"
          }
        }
      ]
    }
  }
}
#minimum_should_match
#Since only should query clauses are specified, at least one of them must match.

GET /products/_search
{
  "query": {
    "bool": {
      "should": [
        {
          "term": {
            "tags.keyword": "Beer"
          }
        },
        {
          "match": {
            "name": "beer"
          }
        }
      ]
    }
  }
}
#Since a must query clause is specified, all of the should query clauses are optional. They are therefore only used to boost the relevance scores of matching documents.

GET /products/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "term": {
            "tags.keyword": "Alcohol"
          }
        }
      ], 
      "should": [
        {
          "term": {
            "tags.keyword": "Beer"
          }
        },
        {
          "match": {
            "name": "beer"
          }
        }
      ]
    }
  }
}
#This behavior can be configured with the minimum_should_match parameter as follows.

GET /products/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "term": {
            "tags.keyword": "Alcohol"
          }
        }
      ], 
      "should": [
        {
          "term": {
            "tags.keyword": "Beer"
          }
        },
        {
          "match": {
            "name": "beer"
          }
        }
      ],
      "minimum_should_match": 1
    }
  }
}
#filter
#Query clauses defined within the filter occurrence type must match. This is similar to the must occurrence type. The difference is that filter query clauses do not affect relevance scores and may be cached.

GET /products/_search
{
  "query": {
    "bool": {
      "filter": [
        {
          "term": {
            "tags.keyword": "Alcohol"
          }
        }
      ]
    }
  }
}
#Examples
#Example #1
#SQL: SELECT * FROM products WHERE (tags IN ("Beer") OR name LIKE '%Beer%') AND in_stock <= 100

#Variation #1

GET /products/_search
{
  "query": {
    "bool": {
      "filter": [
        {
          "range": {
            "in_stock": {
              "lte": 100
            }
          }
        }
      ],
      "must": [
        {
          "bool": {
            "should": [
              { "term": { "tags.keyword": "Beer" } },
              { "match": { "name": "Beer" } }
            ]
          }
        }
      ]
    }
  }
}
#Variation #2

GET /products/_search
{
  "query": {
    "bool": {
      "filter": [
        {
          "range": {
            "in_stock": {
              "lte": 100
            }
          }
        }
      ],
      "should": [
        { "term": { "tags.keyword": "Beer" } },
        { "match": { "name": "Beer" } }
      ],
      "minimum_should_match": 1
    }
  }
}

#Example #2
#SQL: SELECT * FROM products WHERE tags IN ("Beer") AND (name LIKE '%Beer%' OR description LIKE '%Beer%') AND in_stock <= 100

#Variation #1

GET /products/_search
{
  "query": {
    "bool": {
      "filter": [
        {
          "range": {
            "in_stock": {
              "lte": 100
            }
          }
        },
        {
          "term": {
            "tags.keyword": "Beer"
          }
        }
      ],
      "should": [
        { "match": { "name": "Beer" } },
        { "match": { "description": "Beer" } }
      ],
      "minimum_should_match": 1
    }
  }
}
#Variation #2

GET /products/_search
{
  "query": {
    "bool": {
      "filter": [
        {
          "range": {
            "in_stock": {
              "lte": 100
            }
          }
        },
        {
          "term": {
            "tags.keyword": "Beer"
          }
        }
      ],
      "must": [
        {
          "multi_match": {
            "query": "Beer",
            "fields": ["name", "description"]
          }
        }
      ]
    }
  }
}


# Boosting query
# oosting queries are used to assign different levels of importance or relevance to different parts of a query. Boosting can be applied to individual terms, queries, or filters to influence the scoring and ranking of documents in search results.
#Matching juice products
GET /products/_search
{
  "size": 20,
  "query": {
    "match": {
      "name": "juice"
    }
  }
}
#Match juice products, but deprioritize apple juice
GET /products/_search
{
  "size": 20,
  "query": {
    "boosting": {
      "positive": {
        "match": {
          "name": "juice"
        }
      },
      "negative": {
        "match": {
          "name": "apple"
        }
      },
      "negative_boost": 0.5
    }
  }
}
#Without filtering (deprioritize everything apples)
GET /products/_search
{
  "query": {
    "boosting": {
      "positive": {
        "match_all": {}
      },
      "negative": {
        "match": {
          "name": "apple"
        }
      },
      "negative_boost": 0.5
    }
  }
}
#More examples
#"I like pasta"
#Boost the relevance scores for pasta products.

GET /recipes/_search
{
  "query": {
    "bool": {
      "must": [
        { "match_all": {} }
      ], 
      "should": [
        {
          "term": {
            "ingredients.name.keyword": "Pasta"
          }
        }
      ]
    }
  }
}
#"I don't like bacon"
#Reduce the relevance scores for bacon products.

GET /recipes/_search
{
  "query": {
    "boosting": {
      "positive": {
        "match_all": {}
      },
      "negative": {
        "term": {
          "ingredients.name.keyword": "Bacon"
        }
      },
      "negative_boost": 0.5
    }
  }
}
#Pasta products, preferably without bacon
GET /recipes/_search
{
  "query": {
    "boosting": {
      "positive": {
        "term": {
          "ingredients.name.keyword": "Pasta"
        }
      },
      "negative": {
        "term": {
          "ingredients.name.keyword": "Bacon"
        }
      },
      "negative_boost": 0.5
    }
  }
}
#"I like pasta, but not bacon"
GET /recipes/_search
{
  "query": {
    "boosting": {
      "positive": {
        "bool": {
          "must": [
            { "match_all": {} }
          ],
          "should": [
            {
              "term": {
                "ingredients.name.keyword": "Pasta"
              }
            }
          ]
        }
      },
      "negative": {
        "term": {
          "ingredients.name.keyword": "Bacon"
        }
      },
      "negative_boost": 0.5
    }
  }
}

# dis_max query (Disjunction Max Query) is a query that generates the union of documents produced by its subqueries, with each document assigned the maximum score among its matching subqueries. It's useful when you want to find documents that match any of the provided subqueries, and you want to control how scores are calculated and combined.


# Nested object query
#Querying nested objects
#Importing test data
#Follow these instructions and specify recipes-bulk.json as the file name.

#Searching arrays of objects (the wrong way)
GET /recipes/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "ingredients.name": "parmesan"
          }
        },
        {
          "range": {
            "ingredients.amount": {
              "gte": 100
            }
          }
        }
      ]
    }
  }
}
#Create the correct mapping (using the nested data type)
DELETE /recipes
PUT /recipes
{
  "mappings": {
    "properties": {
      "title": { "type": "text" },
      "description": { "type": "text" },
      "preparation_time_minutes": { "type": "integer" },
      "steps": { "type": "text" },
      "created": { "type": "date" },
      "ratings": { "type": "float" },
      "servings": {
        "properties": {
          "min": { "type": "integer" },
          "max": { "type": "integer" }
        }
      },
      "ingredients": {
        "type": "nested",
        "properties": {
          "name": {
            "type": "text",
            "fields": {
              "keyword": {
                "type": "keyword"
              }
            }
          },
          "amount": { "type": "integer" },
          "unit": { "type": "keyword" }
        }
      }
    }
  }
}
#Import the test data again.

#Using the nested query
GET /recipes/_search
{
  "query": {
    "nested": {
      "path": "ingredients",
      "query": {
        "bool": {
          "must": [
            {
              "match": {
                "ingredients.name": "parmesan"
              }
            },
            {
              "range": {
                "ingredients.amount": {
                  "gte": 100
                }
              }
            }
          ]
        }
      }
    }
  }
}

# the inner_hits feature is used with nested queries to retrieve additional information about matches within nested documents. This can be useful when you want to get details about which nested documents contributed to the overall query score or when you need to highlight specific parts of the nested documents.

#Enabling inner hits
GET /recipes/_search
{
  "query": {
    "nested": {
      "path": "ingredients",
      "inner_hits": {},
      "query": {
        "bool": {
          "must": [
            {
              "match": {
                "ingredients.name": "parmesan"
              }
            },
            {
              "range": {
                "ingredients.amount": {
                  "gte": 100
                }
              }
            }
          ]
        }
      }
    }
  }
}
#Specifying custom key and/or number of inner hits
GET /recipes/_search
{
  "query": {
    "nested": {
      "path": "ingredients",
      "inner_hits": {
        "name": "my_hits",
        "size": 10
      }, 
      "query": {
        "bool": {
          "must": [
            { "match": { "ingredients.name": "parmesan" } },
            { "range": { "ingredients.amount": { "gte": 100 } } }
          ]
        }
      }
    }
  }
}




```