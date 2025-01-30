# Slim Containers

## A Lightweight Docker Environment for Full Stack Applications

### Purpose

This is a minimal and ready-to-use Docker setup for developing PHP or Node.js projects.  
It is optimized for development environments, but with minimal adjustments, it can also be used for production.

### Services Provided

- **[PHP-FPM](https://github.com/php/php-src)**: PHP FastCGI Process Manager for handling PHP-based applications.
- **[Node.js](https://github.com/nodejs/node)**: A JavaScript runtime built on Chrome's V8 JavaScript engine.
- **[MariaDB](https://github.com/MariaDB/server)**: An open-source relational database management system, a fork of MySQL.
- **[Nginx](https://github.com/nginx/nginx)**: A high-performance web server and reverse proxy.
- **[Certbot](https://github.com/certbot/certbot)**: For automatic SSL certificate generation and renewal.
- **[Redis](https://github.com/redis/redis)**: A fast, open-source, in-memory data structure store, used as a database, cache, and message broker.
- **[MinIO](https://github.com/minio/minio)**: An open-source object storage service, compatible with Amazon S3.

### Instructions

#### Setup

1. **Add the repository as a submodule:**

    ```bash
    git submodule add https://github.com/VictorMGomes/slim-containers.git
    ```

2. **Copy the example environment file:**

    ```bash
    cp slim-containers/.env.example slim-containers/.env
    ```

3. **Build images:**

    ```bash
    docker-compose -f slim-containers/docker-compose.yml build --no-cache
    ```

#### Usage

- To start selected services in detached mode (background):

    ```bash
    docker-compose -f slim-containers/docker-compose.yml up -d nginx php-fpm mariadb
    ```

- To stop and remove containers:

    ```bash
    docker-compose -f slim-containers/docker-compose.yml down
    ```

### Services Configuration

#### Set up `.env` variables with desired configurations

- **NGINX**  
  You can configure an Nginx reverse proxy by defining the `NGINX_VIRTUAL_HOSTS_CONFIG` variable.  
  The format of `NGINX_VIRTUAL_HOSTS_CONFIG` follows this structure:  
  **`VIRTUAL_HOST_DOMAIN:TEMPLATE_NAME:SERVICE_NAME:PUBLIC_PATH`**,  
  where:  
  - `VIRTUAL_HOST_DOMAIN` is the domain name,  
  - `TEMPLATE_NAME` is the Nginx template,  
  - `SERVICE_NAME` is the container service name,  
  - `PUBLIC_PATH` is the application's public directory (if applicable).  

  **Examples:**  

  - If your application is a Laravel application:  

    ```bash
    NGINX_VIRTUAL_HOSTS_CONFIG="app.local:php-fpm:${PHP_FPM_SERVICE_NAME}:/public"
    ```
  
  - If your application has its root folder as the public folder:  

    ```bash
    NGINX_VIRTUAL_HOSTS_CONFIG="app.local:php-fpm:${PHP_FPM_SERVICE_NAME}:"
    ```
  
  - If your application is a Node.js application:  

    ```bash
    NGINX_VIRTUAL_HOSTS_CONFIG="app.local:nodejs:${NODE_SERVICE_NAME}:"
    ```
  
  - If you have multiple sites with different domains, separated by a comma `,`, for both PHP-FPM and Node.js:  

    ```bash
    NGINX_VIRTUAL_HOSTS_CONFIG="app.local:php-fpm:${PHP_FPM_SERVICE_NAME}:/public,app2.local:nodejs:${NODE_SERVICE_NAME}:"
    ```

  **Important:** For local domains, you need to configure the hosts file of your operating system.  

  - **Windows hosts file path:**  

    ```bash
    C:\Windows\System32\drivers\etc\hosts
    ```

  - **Linux hosts file path:**  

    ```bash
    /etc/hosts
    ```
  
  Add the following lines to your hosts file to map virtual domains:  

  ```bash
  127.0.0.1 app.local
  127.0.0.1 app2.local
  ```

### Contributing

To contribute to this project, please read the contributing **[guide](CONTRIBUTING.md)**.

### Upcoming Features

Check the upcomming features in **[TODO](TODO.md)** of this project.

### Changelog

Check out the release **[changelog](CHANGELOG.md)** for this project.

## 🙏 Funding

***If this project has been useful to you, consider making a donation to help it grow.***

**You can choose a donation method by clicking [here](https://donate.victormgomes.net)**
