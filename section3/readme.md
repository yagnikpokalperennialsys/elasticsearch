```
# Health check document
GET /_cluster/health

#Get all indices
GET _cat/indices

# Get all index data upto 10 results
GET article/_search

# To get the details of nodes
GET _cat/nodes?v

# To create the indices
PUT /products
{
"settings": {
"number_of_replicas": 2,
"number_of_shards": 2
}
}


# Delete indices
DELETE /products

# Add a document
# Query will generate automatic id
POST /products/_doc
{
"name":"Coffee maker",
"price":64,
"in_stock":10
}
# The above query will add shards to 3 because one added to primary shard and 2 added to replica shards

# Query will use our generated ID
POST /products/_doc/1
{
"name":"Coffee maker",
"price":64,
"in_stock":10
}

# GET the id of the document
GET /products/_doc/1


#Perform create operation
POST article/_doc/1
{
"title": "First Article",
"content": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
"author": "John"
}

#Get the all article
GET article/_search

#Perform update operation
PUT article/_doc/1
{
"author": "Yagnik"
}
# Documents are immutable when we use PUT then it will replace entirly

#Perform delete operation
DELETE article/_doc/1
```


``` 
# Query will use our generated ID
POST /products/_doc/1
{
"name":"Coffee maker",
"price":64,
"in_stock":10
}

GET /products/_doc/1

#Update the document
POST /products/_doc/1
{
"doc":{
"in_stock":12
}
}

# Add a script for increseing the in_stock item
POST /products/_update/1
{
  "script":{
    "source":"ctx._source.in_stock--"
  }
  
}

GET /products/_doc/1

# Set the script for assigning the instock to 13

POST /products/_update/1
{
  "script":{
    "source":"ctx._source.in_stock = 13"
  }
  
}

GET /products/_doc/1

# Create a variable and decrese the value by 4

POST /products/_update/1
{
  "script": {
    "source": "ctx._source.in_stock -= params.quantity",
    "params": {
      "quantity":4
    }
  }
}
GET /products/_doc/1


#Upsert is a way of updating or inseting the document wether or not it exists
POST /products/_update/2
{

  "upsert": {
    "name":"Blender",
    "price":399,
    "in_stock":5
  },
    "script":{
    "source":"ctx._source.in_stock++"
  }
}


GET /products/_doc/2

# Replace the documents
PUT /products/_doc/1
{
    "name":"Toaster",
    "price":79,
    "in_stock":4
}

GET /products/_doc/1

DELETE /products/_doc/2

GET /products/_doc/2

#routing stretegy will use when we perform CRUD operatins ES will use default reouting untill unless we specified specific
# The formula is shard_num = hash(_routing) % num_primary_shards

# Read and write operation perform by ASR
# Write operation have local and globle checkpoints
# Version of document managed by the increment the counter we can not get hostory of the doc but jut we got is only last version


# Optimistic concurrency controll
# consider 2 person have same item available in there cart
# stock is 6 pieces one needed 4 peices and another needed 3 pieces but stock is 6
# Then it creates issue while seond is trying to buy the item
# we can acheave this using the if_primary_term and if_seq_num
# From our application we have to use the both paramter and its increment and decrement order




GET /products/_doc/1

POST /products/_update/1?if_primary_term=2&if_seq_no=19
{
  "doc":{
    "in_stock":11
  }
}

# Update the document by query
# Update multiple documents
POST /products/_update_by_query
{
  "script": {
    "source": "ctx._source.in_stock--"
  }, 
  "query": {
    "match_all": {}
  }
}

# _search will get all the douments for products indices
GET /products/_search


# Delete by query
# Delete multiple documents
POST /products/_delete_by_query
{
  "query":{
    "match_all":{}
  }
}

GET /products/_search



# Bulk add items
# While using bulk action we must set the Content-Type to application/x-ndjson
# Application/json is accpted but thats not a correct way
#For bulk upload make sure to use /n and last line empty in file
POST /products/_bulk
  { "index" : {"_index":"products","_id":200 } }
  {"name":"Espresso machine","price":199,"in_stock":5}
  {"index":{"_index":"products","_id":201}}
  {"name":"Milk frother","price":148,"in_stock":14}
  
GET /products/_search

# Perform the update and delete operation in bulk
POST /products/_bulk
{"update":{"_id":201}}
{"doc":{"price":129}}
{"delete":{"_id":200}}

GET /products/_search

# To check status pf shard and the amount of the data it have
GET /_cat/shards?v
```
Upload the bulk data using the file
Download the file from the https://github.com/codingexplained/complete-guide-to-elasticsearch/blob/master/products-bulk.json
```
curl --location 'https://localhost:9200/products/_bulk' \
--header 'Content-Type: application/x-ndjson' \
--header 'Authorization: Basic ZWxhc3RpYzpXa3pzSl83UF9JakFTN3A5aGRMRw==' \
--data '@/Users/perennial/Downloads/products-bulk.json'
```
Below command will use to see how many documents are attatched to shards
``` 
GET /_cat/shards?v
```
Referance
For more information to send the file to elastic cloud refer

https://github.com/codingexplained/complete-guide-to-elasticsearch/blob/master/Managing%20Documents/importing-data-with-curl.md
