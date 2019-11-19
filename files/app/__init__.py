from flask import Flask

# mainpage.py contains 'from app import app'
# To start using gunicorn - gunicorn app:app
app = Flask(__name__)

from app import routes
