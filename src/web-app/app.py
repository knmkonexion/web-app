"""Main application module"""
import os
from flask import Flask, render_template
from prometheus_flask_exporter import PrometheusMetrics
from flaskext.mysql import MySQL

app = Flask(__name__)
metrics = PrometheusMetrics(app)

# Create a connection to the database
mysql = MySQL()
app.config['MYSQL_DATABASE_HOST'] = os.getenv('DB_HOST')
app.config['MYSQL_DATABASE_USER'] = 'root'
app.config['MYSQL_DATABASE_DB'] = 'blog'
app.config['MYSQL_DATABASE_SOCKET'] = None
app.config['MYSQL_DATABASE_PASSWORD'] = os.getenv('MYSQL_DATABASE_PASSWORD')
mysql.init_app(app)

@app.route('/')
def home():
    """Home route, pulls homepage content from database"""
    conn = mysql.connect()
    cursor = conn.cursor()
    cursor.execute('SELECT greeting from website')
    greeting = cursor.fetchone()
    return render_template('home.html', greeting=greeting)

@app.route('/blog')
def blog():
    """Blog route, pulls blog posts from database"""
    conn = mysql.connect()
    cursor = conn.cursor()
    cursor.execute('SELECT title from blog')
    blog_posts = cursor.fetchall()
    return render_template('blog.html', blog_posts=blog_posts)

@app.route('/health-check')
def health_check():
    """Health check should perform a simple DB query to ensure the connection is good"""
    conn = mysql.connect()
    cursor = conn.cursor()
    cursor.execute('SELECT 1')
    return 'success'

@app.route('/test')
def test_route():
    """Route used for pytest"""
    return 'success'

# For use in development - use a WSGI for production
if __name__ == "__main__":
    app.run(host='0.0.0.0', debug=True)
