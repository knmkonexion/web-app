import os
from flask import Flask, request, jsonify, render_template
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

# Generate routes (make sure there is a new connection for sql for each route)
@app.route('/')
def home():
		conn = mysql.connect()
		cursor = conn.cursor()
		cursor.execute('SELECT greeting from website')
		greeting = cursor.fetchone()
		return render_template('home.html', greeting=greeting)

@app.route('/blog')
def blog():
		conn = mysql.connect()
		cursor = conn.cursor()
		cursor.execute('SELECT title from blog')
		blog_posts = cursor.fetchall()
		return render_template('blog.html', blog_posts=blog_posts)

# Health check should perform a simple DB query to ensure the connection is good
@app.route('/health-check')
def health_check():
		conn = mysql.connect()
		cursor = conn.cursor()
		cursor.execute('SELECT 1')
		return 'success'

@app.route('/test')
def test_route():
		return 'success'

# For use in development - use a WSGI for production
if __name__ == "__main__":
	app.run(host='0.0.0.0', debug=True)