#!/bin/bash
set -x #echo on

clear
echo "To get the status of your cluster"
curl -i -X GET http://localhost:9200/_cluster/health?pretty
read -p "Press [Enter] key to continue..." && clear

echo "Create indices(index) :  Indices are created using PUT method. "
curl -X PUT 'localhost:9200/techtalks?&pretty'   
read -p "Press [Enter] key to continue..." && clear

echo "Display list of indices(index) : GET method is used to display indices"
curl -XGET 'localhost:9200/_cat/indices?v&pretty'
read -p "Press [Enter] key to continue..." && clear

echo "Add document in index :
 PUT method is used to create documents in index."
curl -XPUT 'localhost:9200/techtalks/lectors/1?pretty' -d'{"name":"Dmitry Kovalevsky","age":53,"gender":"male","email":"dima_kavalevsky@epam.com","phone":"+375 (29) 7336-41","street":"29 Zukova","city":"Minsk","state":"Minsk area, 3711"}' -H 'Content-Type: application/json'
read -p "Press [Enter] key to continue..." && clear

curl -XPUT 'localhost:9200/techtalks/lectors/2?pretty' -d'{"name":"Irina Mishkevich","age":31,"gender":"female","email":"Irina_Mishkevich@gmail.com","phone":"+375 (33) 499-3611","street":"14 Sovetskaya street","city":"Brest","state":"Brest, 118"}' -H 'Content-Type: application/json'
read -p "Press [Enter] key to continue..." && clear

echo "Display Document :
 GET command is used to display document."
curl -XGET 'localhost:9200/techtalks/lectors/1?pretty'
read -p "Press [Enter] key to continue..." && clear


echo "Update whole document : 
 PUT method is used to update whole document in given index."
curl -XPUT 'localhost:9200/techtalks/lectors/2?pretty' -d'{"name":"Mishel Shubin","age":35,"gender":"male","email":"shubin@mail.ru","phone":"+488 (15) 567-2131","street":"173 Beresovskaya street","city":"Moskow","state":"Russia , 5"}' -H 'Content-Type: application/json'
read -p "Press [Enter] key to continue..." && clear

echo "Update partial document :  
 POST method is used to update document in given index. In order to update document fields we have to specify JSON with key value 'doc'."
curl -XPOST 'localhost:9200/techtalks/lectors/1/_update?pretty' -d'
{
  "doc": {
     "age": "24",
     "city":"Boris"
  }
}
' -H 'Content-Type: application/json'
read -p "Press [Enter] key to continue..." && clear

echo "Verify whether document has been updated with new value. Execute display document command with specific fields."
curl -XGET 'localhost:9200/techtalks/lectors/1?pretty&_source=name,age,city'
read -p "Press [Enter] key to continue..." && clear

echo "Delete Index :  DELETE method is used to delete index."
curl -XDELETE 'localhost:9200/techtalks?pretty' 
read -p "Press [Enter] key to continue..." && clear


echo "Get the following information for each index in a cluster"
curl localhost:9200/_cat/indices?v
read -p "Press [Enter] key to continue..." && clear