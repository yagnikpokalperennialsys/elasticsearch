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