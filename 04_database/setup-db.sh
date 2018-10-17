rm -rf ./data || /bin/true
mkdir ./data

# Run the container.  The following command creates a database named 'my_app',
# specifies the root user password as 'root', and adds a user named vault
docker run --name mysql-demo \
  -p 3306:3306 \
  -v ./data/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=root \
  -e MYSQL_ROOT_HOST=% \
  -e MYSQL_DATABASE=my_app \
  -e MYSQL_USER=vault \
  -e MYSQL_PASSWORD=vault \
  -d mysql/mysql-server:5.7
