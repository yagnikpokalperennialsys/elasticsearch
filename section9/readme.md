``` 
# Proximity searches in Elasticsearch involve searching for terms that are located close to each other within a certain proximity or distance in a text. 
# Proximity searches
#Adding test documents
PUT /proximity/_doc/1
{
  "title": "Spicy Sauce"
}
PUT /proximity/_doc/2
{
  "title": "Spicy Tomato Sauce"
}
PUT /proximity/_doc/3
{
  "title": "Spicy Tomato and Garlic Sauce"
}
PUT /proximity/_doc/4
{
  "title": "Tomato Sauce (spicy)"
}
PUT /proximity/_doc/5
{
  "title": "Spicy and very delicious Tomato Sauce"
}
#Adding the slop parameter to a match_phrase query
GET /proximity/_search
{
  "query": {
    "match_phrase": {
      "title": {
        "query": "spicy sauce",
        "slop": 1
      }
    }
  }
}
GET /proximity/_search
{
  "query": {
    "match_phrase": {
      "title": {
        "query": "spicy sauce",
        "slop": 2
      }
    }
  }
}

# Affecting relevance scoring with proximity
#A simple match query within a bool query
GET /proximity/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "title": {
              "query": "spicy sauce"
            }
          }
        }
      ]
    }
  }
}
#Boosting relevance based on proximity
GET /proximity/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "title": {
              "query": "spicy sauce"
            }
          }
        }
      ],
      "should": [
        {
          "match_phrase": {
            "title": {
              "query": "spicy sauce"
            }
          }
        }
      ]
    }
  }
}
#Adding the slop parameter
GET /proximity/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "title": {
              "query": "spicy sauce"
            }
          }
        }
      ],
      "should": [
        {
          "match_phrase": {
            "title": {
              "query": "spicy sauce",
              "slop": 5
            }
          }
        }
      ]
    }
  }
}

# A fuzzy match query in Elasticsearch is used to perform approximate matching on a field. It allows you to search for terms that are similar to, but not exactly like, the specified term. 
# Fuzzy match query
#Searching with fuzziness set to auto
GET /products/_search
{
  "query": {
    "match": {
      "name": {
        "query": "l0bster",
        "fuzziness": "auto"
      }
    }
  }
}
GET /products/_search
{
  "query": {
    "match": {
      "name": {
        "query": "lobster",
        "fuzziness": "auto"
      }
    }
  }
}
#Fuzziness is per term (and specifying an integer)
GET /products/_search
{
  "query": {
    "match": {
      "name": {
        "query": "l0bster love",
        "operator": "and",
        "fuzziness": 1
      }
    }
  }
}
#Switching letters around with transpositions
GET /products/_search
{
  "query": {
    "match": {
      "name": {
        "query": "lvie",
        "fuzziness": 1
      }
    }
  }
}
#Disabling transpositions
GET /products/_search
{
  "query": {
    "match": {
      "name": {
        "query": "lvie",
        "fuzziness": 1,
        "fuzzy_transpositions": false
      }
    }
  }
}

# fuzzy query
GET /products/_search
{
  "query": {
    "fuzzy": {
      "name": {
        "value": "LOBSTER",
        "fuzziness": "auto"
      }
    }
  }
}
GET /products/_search
{
  "query": {
    "fuzzy": {
      "name": {
        "value": "lobster",
        "fuzziness": "auto"
      }
    }
  }
}

# Synonims
# In Elasticsearch, synonyms can be defined to expand or enhance the search capabilities by considering different terms as equivalent. Synonyms are helpful when you want to ensure that a search for one term also includes documents containing its synonyms.
# Adding synonyms
#Creating index with custom analyzer
PUT /synonyms
{
  "settings": {
    "analysis": {
      "filter": {
        "synonym_test": {
          "type": "synonym", 
          "synonyms": [
            "awful => terrible",
            "awesome => great, super",
            "elasticsearch, logstash, kibana => elk",
            "weird, strange"
          ]
        }
      },
      "analyzer": {
        "my_analyzer": {
          "tokenizer": "standard",
          "filter": [
            "lowercase",
            "synonym_test"
          ]
        }
      }
    }
  },
  "mappings": {
    "properties": {
      "description": {
        "type": "text",
        "analyzer": "my_analyzer"
      }
    }
  }
}
#Testing the analyzer (with synonyms)
POST /synonyms/_analyze
{
  "analyzer": "my_analyzer",
  "text": "awesome"
}
POST /synonyms/_analyze
{
  "analyzer": "my_analyzer",
  "text": "Elasticsearch"
}
POST /synonyms/_analyze
{
  "analyzer": "my_analyzer",
  "text": "weird"
}
POST /synonyms/_analyze
{
  "analyzer": "my_analyzer",
  "text": "Elasticsearch is awesome, but can also seem weird sometimes."
}
#Adding a test document
POST /synonyms/_doc
{
  "description": "Elasticsearch is awesome, but can also seem weird sometimes."
}
#Searching the index for synonyms
GET /synonyms/_search
{
  "query": {
    "match": {
      "description": "great"
    }
  }
}
GET /synonyms/_search
{
  "query": {
    "match": {
      "description": "awesome"
    }
  }
}

#Adding synonyms from file
#Adding index with custom analyzer
PUT /synonyms
{
  "settings": {
    "analysis": {
      "filter": {
        "synonym_test": {
          "type": "synonym",
          "synonyms_path": "analysis/synonyms.txt"
        }
      },
      "analyzer": {
        "my_analyzer": {
          "tokenizer": "standard",
          "filter": [
            "lowercase",
            "synonym_test"
          ]
        }
      }
    }
  },
  "mappings": {
    "properties": {
      "description": {
        "type": "text",
        "analyzer": "my_analyzer"
      }
    }
  }
}
#Synonyms file (config/analysis/synonyms.txt)
# This is a comment

#awful => terrible
#awesome => great, super
#elasticsearch, logstash, kibana => elk
#weird, strange
#Testing the analyzer
POST /synonyms/_analyze
{
  "analyzer": "my_analyzer",
  "text": "Elasticsearch"
}


# Highlighting matches in fields
#Adding a test document
PUT /highlighting/_doc/1
{
  "description": "Let me tell you a story about Elasticsearch. It's a full-text search engine that is built on Apache Lucene. It's really easy to use, but also packs lots of advanced features that you can use to tweak its searching capabilities. Lots of well-known and established companies use Elasticsearch, and so should you!"
}
#Highlighting matches within the description field
GET /highlighting/_search
{
  "_source": false,
  "query": {
    "match": { "description": "Elasticsearch story" }
  },
  "highlight": {
    "fields": {
      "description" : {}
    }
  }
}
#Specifying a custom tag
GET /highlighting/_search
{
  "_source": false,
  "query": {
    "match": { "description": "Elasticsearch story" }
  },
  "highlight": {
    "pre_tags": [ "<strong>" ],
    "post_tags": [ "</strong>" ],
    "fields": {
      "description" : {}
    }
  }
}

# Stemming
#Creating a test index
PUT /stemming_test
{
  "settings": {
    "analysis": {
      "filter": {
        "synonym_test": {
          "type": "synonym",
          "synonyms": [
            "firm => company",
            "love, enjoy"
          ]
        },
        "stemmer_test" : {
          "type" : "stemmer",
          "name" : "english"
        }
      },
      "analyzer": {
        "my_analyzer": {
          "tokenizer": "standard",
          "filter": [
            "lowercase",
            "synonym_test",
            "stemmer_test"
          ]
        }
      }
    }
  },
  "mappings": {
    "properties": {
      "description": {
        "type": "text",
        "analyzer": "my_analyzer"
      }
    }
  }
}
#Adding a test document
PUT /stemming_test/_doc/1
{
  "description": "I love working for my firm!"
}
#Matching the document with the base word (work)
GET /stemming_test/_search
{
  "query": {
    "match": {
      "description": "enjoy work"
    }
  }
}
#The query is stemmed, so the document still matches
GET /stemming_test/_search
{
  "query": {
    "match": {
      "description": "love working"
    }
  }
}
#Synonyms and stemmed words are still highlighted
GET /stemming_test/_search
{
  "query": {
    "match": {
      "description": "enjoy work"
    }
  },
  "highlight": {
    "fields": {
      "description": {}
    }
  }
}
```