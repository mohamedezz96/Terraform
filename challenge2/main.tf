resource "docker_image" "php-httpd-image" {
  name = "php-httpd:challenge"
  build {
    path = "lamp_stack/php_httpd"
    label = {
      challenge : "second"
    }
  }
}


resource "docker_image" "mariadb-image" {
  name = "mariadb:challenge"
  build {
    path = "lamp_stack/custom_db"
    label = {
      challenge : "second"
    }
  }
}

resource "docker_network" "private_network" {
  name = "my_network"
  attachable = true
  labels {
        label = "challenge"
        value = "second"
 }
}


resource "docker_container" "php-httpd" {
   name = "webserver"
   image = "php-httpd:challenge"
   hostname = "php-httpd"
   networks_advanced {
         name = "my_network"
  }
   ports {

        internal = 80
  }
   labels {
        label = "challenge"
        value = "second"
  }
   volumes {

        host_path = "/root/code/terraform-challenges/challenge2/lamp_stack/website_content/" 
        container_path = "/var/www/html"
  } 
}





resource "docker_container" "mariadb" {
   name = "db"
   image = "mariadb:challenge"
   hostname = "db"
   networks_advanced {
         name = "my_network"
  }
   ports {

        internal = 3306
  }
   labels {
        label = "challenge"
        value = "second"
  }
   env = [
        "MYSQL_ROOT_PASSWORD=1234"
        "MYSQL_DATABASE=simple-website"
        ]
}
