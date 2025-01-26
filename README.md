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

### Contributing

To contributing with this project read the contributing **[guide](CONTRIBUTING.md)**.

### Upcomming features

Check the upcomming features in **[TODO](TODO.md)** of this project.

### Changelog

Checkout the releases **[changelogS](CHANGELOG.md)** of this project.

## 🙏 Donations

***If this project has been useful to you, consider making a donation to help it grow.***

**You can choose a donation method by clicking [here](https://donate.victormgomes.net)**
