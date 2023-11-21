``` 

# Create a text anylyzer default standard
POST /products/_analyze
{
  "text":"2 guys walks into   a bar, but the third... DUCKS! :-)",
  "analyzer":"standard"
}


# Create standard analyzer with char_filter, tokenizer, fiklter
POST /products/_analyze
{
  "text":"2 guys walks into   a bar, but the third... DUCKS! :-)",
  "char_filter":[],
  "tokenizer":"standard",
  "filter":["lowercase"]
}

PUT /employees
{
  "mappings": {
    "properties": {
      "id":{"type": "integer"},
      "first_name":{"type": "text"},
      "dob":{"type": "date"}
    }
  }
}

#Nested datatypes

{
  "name":"coffee maker",
  "reviews":{
    {
    "rating":5,
    "author":"average joy"
    },
    {
    "rating":3.5,
    "author":"John doe"
    }
  }
}


# Coersion datatypes
# Elastic search will automatically convert the datatype to relative datatype
# Consider below

#
PUT /coersion_index/_doc/1
{
  "price":8
}

# if define price at int in mapping then it will convert string to float else keep as it is
PUT /coersion_index/_doc/2
{
  "price":"8"
}

GET /coersion_index/_search

GET /coersion_index/_doc/1


# Array in ES
POST /products/_doc
{
  "tags":"smartphone"
}

# Both above and below are same since while using the analyze it will converted into a token
POST /products/_doc
{
  "tags":["smartphone", "electronics"]
}


# create mapping 
PUT /reviews
{
  "mappings": {
    "properties": {
      "rating": { "type": "float" },
      "content": { "type": "text" },
      "product_id": { "type": "integer" },
      "author": {
        "properties": {
          "first_name": { "type": "text" },
          "last_name": { "type": "text" },
          "email": { "type": "keyword" }
        }
      }
    }
  }
}

# Index a test document
PUT /reviews/_doc/1
{
  "rating": "5.0",
  "content": "Outstanding course! Bo really taught me a lot about Elasticsearch!",
  "product_id": "123",
  "author": {
    "first_name": 1,
    "last_name": "Doe",
    "email": "johndoe123@example.com"
  }
}


# Retrieving mappings for the reviews index
GET /reviews/_mapping

# Retrieving mapping for the content field
GET /reviews/_mapping/field/content

#https://github.com/codingexplained/complete-guide-to-elasticsearch/blob/master/Mapping%20%26%20Analysis/retrieving-mappings.md


# Create the above notation using the dot notation both are same above and below
PUT /reviews_dot_notation
{
  "mappings": {
    "properties": {
      "rating": { "type": "float" },
      "content": { "type": "text" },
      "product_id": { "type": "integer" },
      "author.first_name": { "type": "text" },
      "author.last_name": { "type": "text" },
      "author.email": { "type": "keyword" }
    }
  }
}

# Retrieving mappings for the reviews index
GET /reviews/_mapping

# Adding mappings to existing indices
PUT /reviews/_mapping
{
  "properties": {
    "created_at": {
      "type": "date"
    }
  }
}

# Retrieving mappings for the reviews index
GET /reviews/_mapping


# Dates in the ES
#How dates work in Elasticsearch
#Supplying only a date
PUT /reviews/_doc/2
{
  "rating": 4.5,
  "content": "Not bad. Not bad at all!",
  "product_id": 123,
  "created_at": "2015-03-27",
  "author": {
    "first_name": "Average",
    "last_name": "Joe",
    "email": "avgjoe@example.com"
  }
}



# Supplying both a date and time
# by default UTC time is set
# Can give date, date + time, millisecond epoh
PUT /reviews/_doc/3
{
  "rating": 3.5,
  "content": "Could be better",
  "product_id": 123,
  "created_at": "2015-04-15T13:07:41Z",
  "author": {
    "first_name": "Spencer",
    "last_name": "Pearson",
    "email": "spearson@example.com"
  }
}
# Specifying the UTC offset
PUT /reviews/_doc/4
{
  "rating": 5.0,
  "content": "Incredible!",
  "product_id": 123,
  "created_at": "2015-01-28T09:21:51+01:00",
  "author": {
    "first_name": "Adam",
    "last_name": "Jones",
    "email": "adam.jones@example.com"
  }
}
# Supplying a timestamp (milliseconds since the epoch)
# Equivalent to 2015-07-04T12:01:24Z
PUT /reviews/_doc/5
{
  "rating": 4.5,
  "content": "Very useful",
  "product_id": 123,
  "created_at": 1436011284000,
  "author": {
    "first_name": "Taylor",
    "last_name": "West",
    "email": "twest@example.com"
  }
}
# Retrieving documents
GET /reviews/_search
{
  "query": {
    "match_all": {}
  }
}

#  Missing fields
# All the field in ES are optinal
# Searches will automatically handles missing values



# Parameters
# Date parameter
PUT /sales
{
  "mappings": {
    "properties": {
      "creatted_at":{
      "type":"date",
      "formate":"dd/mm/yyyy"
    }
    }
  }
}

# Property parameter
PUT my-index-000001
{
  "mappings": {
    "properties": { 
      "manager": {
        "properties": { 
          "age":  { "type": "integer" },
          "name": { "type": "text"  }
        }
      },
      "employees": {
        "type": "nested",
        "properties": { 
          "age":  { "type": "integer" },
          "name": { "type": "text"  }
        }
      }
    }
  }
}

GET my-index-000001

# Coerse parameter
PUT my-index-000002
{
  "mappings": {
    "properties": {
      "number_one": {
        "type": "integer"
      },
      "number_two": {
        "type": "integer",
        "coerce": false
      }
    }
  }
}

PUT my-index-000001/_doc/1
{
  "number_one": "10" 
}

PUT my-index-000001/_doc/2
{
  "number_two": "10" 
}

GET my-index-000001/_doc/2

# Disable doc_value
PUT my-index-000003
{
  "mappings": {
    "properties": {
      "status_code": { 
        "type":       "keyword"
      },
      "session_id": { 
        "type":       "keyword",
        "doc_values": false
      }
    }
  }
}

# norms parameter
# used for the relavence scoring and filtering

PUT my-index-000001/_mapping
{
  "properties": {
    "title": {
      "type": "text",
      "norms": false
    }
  }
}

# index parameter
# used if dont want to use search for query
PUT /my_index1
{
  "mappings": {
    "properties": {
      "field1": {
        "type": "text"
      },
      "field2": {
        "type": "keyword",
        "index": false
      }
    }
  }
}



#null_value parameter
# Can not be indexed or searched
PUT /my_index
{
  "mappings": {
    "properties": {
      "my_field": {
        "type": "keyword",
        "null_value": "false"
      }
    }
  }
}


#Copyto parameter
# The "copy_to" parameter in Elasticsearch is used to create a copy of the values from one or more fields into a target field. 
PUT /my_index2
{
  "mappings": {
    "properties": {
      "first_name": {
        "type": "text",
        "copy_to": "full_name"
      },
      "last_name": {
        "type": "text",
        "copy_to": "full_name"
      },
      "full_name": {
        "type": "text"
      }
    }
  }
}


#Reindexing documents with the Reindex API
# Reindexing in Elasticsearch involves copying documents from one index to another. This can be useful for various scenarios such as changing the index settings, updating the mapping, or migrating data between different versions of Elasticsearch.
#Add new index with new mapping
PUT /reviews_new
{
  "mappings" : {
    "properties" : {
      "author" : {
        "properties" : {
          "email" : {
            "type" : "keyword",
            "ignore_above" : 256
          },
          "first_name" : {
            "type" : "text"
          },
          "last_name" : {
            "type" : "text"
          }
        }
      },
      "content" : {
        "type" : "text"
      },
      "created_at" : {
        "type" : "date"
      },
      "product_id" : {
        "type" : "keyword"
      },
      "rating" : {
        "type" : "float"
      }
    }
  }
}
#Retrieve mapping
GET /reviews/_mappings
#Reindex documents into reviews_new
POST /_reindex
{
  "source": {
    "index": "reviews"
  },
  "dest": {
    "index": "reviews_new"
  }
}
#Delete all documents
POST /reviews_new/_delete_by_query
{
  "query": {
    "match_all": {}
  }
}
#Convert product_id values to strings
POST /_reindex
{
  "source": {
    "index": "reviews"
  },
  "dest": {
    "index": "reviews_new"
  },
  "script": {
    "source": """
      if (ctx._source.product_id != null) {
        ctx._source.product_id = ctx._source.product_id.toString();
      }
    """
  }
}
#Retrieve documents
GET /reviews_new/_search
{
  "query": {
    "match_all": {}
  }
}
#Reindex specific documents
POST /_reindex
{
  "source": {
    "index": "reviews",
    "query": {
      "match_all": { }
    }
  },
  "dest": {
    "index": "reviews_new"
  }
}
#Reindex only positive reviews
POST /_reindex
{
  "source": {
    "index": "reviews",
    "query": {
      "range": {
        "rating": {
          "gte": 4.0
        }
      }
    }
  },
  "dest": {
    "index": "reviews_new"
  }
}
#Removing fields (source filtering)
POST /_reindex
{
  "source": {
    "index": "reviews",
    "_source": ["content", "created_at", "rating"]
  },
  "dest": {
    "index": "reviews_new"
  }
}
#Changing a field's name
POST /_reindex
{
  "source": {
    "index": "reviews"
  },
  "dest": {
    "index": "reviews_new"
  },
  "script": {
    "source": """
      # Rename "content" field to "comment"
      ctx._source.comment = ctx._source.remove("content");
    """
  }
}
#Ignore reviews with ratings below 4.0
POST /_reindex
{
  "source": {
    "index": "reviews"
  },
  "dest": {
    "index": "reviews_new"
  },
  "script": {
    "source": """
      if (ctx._source.rating < 4.0) {
        ctx.op = "noop"; # Can also be set to "delete"
      }
    """
  }
}

# Field allias
#Defining field aliases
#Add comment alias pointing to the content field
PUT /reviews/_mapping
{
  "properties": {
    "comment": {
      "type": "alias",
      "path": "content"
    }
  }
}
#Using the field alias
GET /reviews/_search
{
  "query": {
    "match": {
      "comment": "outstanding"
    }
  }
}
#Using the "original" field name still works
GET /reviews/_search
{
  "query": {
    "match": {
      "content": "outstanding"
    }
  }
}


#Multi-field mappings
# In Elasticsearch, multi-field mappings allow you to index a single field in multiple ways, each with its own mapping. This can be particularly useful when you need to perform different types of searches (e.g., full-text search and keyword search) on the same field.
#Add keyword mapping to a text field
PUT /multi_field_test
{
  "mappings": {
    "properties": {
      "description": {
        "type": "text"
      },
      "ingredients": {
        "type": "text",
        "fields": {
          "keyword": {
            "type": "keyword"
          }
        }
      }
    }
  }
}
#Index a test document
POST /multi_field_test/_doc
{
  "description": "To make this spaghetti carbonara, you first need to...",
  "ingredients": ["Spaghetti", "Bacon", "Eggs"]
}
#Retrieve documents
GET /multi_field_test/_search
{
  "query": {
    "match_all": {}
  }
}
#Querying the text mapping
GET /multi_field_test/_search
{
  "query": {
    "match": {
      "ingredients": "Spaghetti"
    }
  }
}
#Querying the keyword mapping
GET /multi_field_test/_search
{
  "query": {
    "term": {
      "ingredients.keyword": "Spaghetti"
    }
  }
}
#Clean up
DELETE /multi_field_test

# Index templating
# index template is a way to define settings and mappings that will be applied automatically when new indices are created. 
#Adding an index template named access-logs
PUT /_template/access-logs
{
  "index_patterns": ["access-logs-*"],
  "settings": {
    "number_of_shards": 2,
    "index.mapping.coerce": false
  }, 
  "mappings": {
    "properties": {
      "@timestamp": {
        "type": "date"
      },
      "url.original": {
        "type": "keyword"
      },
      "http.request.referrer": {
        "type": "keyword"
      },
      "http.response.status_code": {
        "type": "long"
      }
    }
  }
}
#Adding an index matching the index template's pattern
PUT /access-logs-2020-01-01
#Verify that the mapping is applied
GET /access-logs-2020-01-01

# Combining the explicit and dynamic mapping
#Combining explicit and dynamic mapping
#Create index with one field mapping
PUT /people
{
  "mappings": {
    "properties": {
      "first_name": {
        "type": "text"
      }
    }
  }
}
#Index a test document with an unmapped field
POST /people/_doc/5
{
  "first_name": "Bo",
  "last_name": "Andersen"
}
#Retrieve mapping
GET /people/_mapping

GET /people/_doc/5

#Clean up
DELETE /people

#Configuring dynamic mapping
#Disable dynamic mapping
PUT /people
{
  "mappings": {
    "dynamic": false,
    "properties": {
      "first_name": {
        "type": "text"
      }
    }
  }
}



#Set dynamic mapping to strict
PUT /people
{
  "mappings": {
    "dynamic": "strict",
    "properties": {
      "first_name": {
        "type": "text"
      }
    }
  }
}
#Index a test document
POST /people/_doc
{
  "first_name": "Bo",
  "last_name": "Andersen"
}
#Retrieve mapping
GET /people/_mapping
#Search first_name field
GET /people/_search
{
  "query": {
    "match": {
      "first_name": "Bo"
    }
  }
}
#Search last_name field
GET /people/_search
{
  "query": {
    "match": {
      "last_name": "Andersen"
    }
  }
}
#Inheritance for the dynamic parameter
#The following example sets the dynamic parameter to "strict" at the root level, but overrides it with a value of true for the specifications.other field mapping.

#Mapping
PUT /computers
{
  "mappings": {
    "dynamic": "strict",
    "properties": {
      "name": {
        "type": "text"
      },
      "specifications": {
        "properties": {
          "cpu": {
            "properties": {
              "name": {
                "type": "text"
              }
            }
          },
          "other": {
            #New fields are automatically added to the mapping when encountered in a document.
            "dynamic": true,
            "properties": { "..." }
          }
        }
      }
    }
  }
}
#Example document (invalid)

POST /computers/_doc
{
  "name": "Gamer PC",
  "specifications": {
    "cpu": {
      "name": "Intel Core i7-9700K",
      "frequency": 3.6
    }
  }
}
#Example document (OK)
POST /computers/_doc
{
  "name": "Gamer PC",
  "specifications": {
    "cpu": {
      "name": "Intel Core i7-9700K"
    },
    "other": {
      "security": "Kensington"
    }
  }
}
# Enabling numeric detection
#When enabling numeric detection, Elasticsearch will check the contents of strings to see if they contain only numeric values - and map the fields accordingly as either float or long.

#Mapping
PUT /computers
{
  "mappings": {
    "numeric_detection": true
  }
}
#Example document
POST /computers/_doc
{
  "specifications": {
    "other": {
      "max_ram_gb": "32", # long
      "bluetooth": "5.2" # float
    }
  }
}
#Date detection
#Disabling date detection
PUT /computers
{
  "mappings": {
    "date_detection": false
  }
}
#Configuring dynamic date formats
PUT /computers
{
  "mappings": {
    "dynamic_date_formats": ["dd-MM-yyyy"]
  }
}
#Clean up
DELETE /people

# dynamic: true (default):
#New fields are automatically added to the mapping when encountered in a document.

PUT /my_index
{
  "mappings": {
    "dynamic": true,
    "properties": {
      "field1": { "type": "text" }
    }
  }
}

#dynamic: false:
# New fields are ignored and not added to the mapping.
PUT /my_index
{
  "mappings": {
    "dynamic": false,
    "properties": {
      "field1": { "type": "text" }
    }
  }
}

# dynamic: strict:
#Similar to dynamic: false, new fields are not added to the mapping.
#Additionally, if a document contains a new field, and the inferred data type is different from the one specified in the mapping, an exception is thrown.
PUT /my_index
{
  "mappings": {
    "dynamic": "strict",
    "properties": {
      "field1": { "type": "text" }
    }
  }
}
```