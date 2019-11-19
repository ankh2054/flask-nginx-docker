![License MIT](https://img.shields.io/badge/license-MIT-blue.svg)

### TO-DO

update settings.py with following:

	STATIC_URL = '/static/'
	STATIC_ROOT = os.path.join(BASE_DIR, 'static')


# DJANGO-DOCKER

django-docker sets up a container running django, gunicorn python, based on variables provided. It will automatically start gunicorn using the WSGI variable provided. 

If using Letsencrypt to automate the creation of a SSL certificate, you need to follow the Nginx-proxy Usage - to enable SSL support guidelines at the bottom of this page.


### DJANGO-DOCKER Usage


Firstly you need to create the necessary folders on your docker host. The container will expose directories created below directly into the container to ensure our WWW, and LOG folders are persistent.
This ensures that even if your container is lost or deleted, you won't loose your DJANGO database or website files.

	$ mkdir -p /data/sites/www.test.co.uk/www
	$ mkdir -p /data/sites/www.test.co.uk/logs



### To buld the docker django image:

		$ cd django/
		$ docker build https://github.com/ankh2054/flask-docker-nginx.git -t flask-nginx 

### To run it with LETSENCRYPT:

    $ docker run  --name www.test.co.uk --expose 80 \
	 -d -e "VIRTUAL_HOST=nginx.42strings.co.uk" \
	 -e 'FLASK_APP_NAME=test' \ 
 	 -e "LETSENCRYPT_HOST=nginx.42strings.co.uk" \
	 -e "LETSENCRYPT_EMAIL=info@42strings.co.uk \
	 -e 'PIP_PACKAGES=flask==1.1.1 gunicorn' \
	 -v /data/sites/www.test.co.uk/mysql:/var/lib/mysql \
	 -v /data/sites/www.test.co.uk:/DATA flask-nginx


