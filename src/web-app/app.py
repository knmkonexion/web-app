import os
from flask import Flask, request, jsonify, render_template
from prometheus_flask_exporter import PrometheusMetrics
from flaskext.mysql import MySQL

app = Flask(__name__)
metrics = PrometheusMetrics(app)

# static information as metric
metrics.info('app_info', 'Application info', version='0.1.0')

# Create a connection to the database
mysql = MySQL()
app.config['MYSQL_DATABASE_USER'] = os.environ.get('DB_USER')
app.config['MYSQL_DATABASE_PASSWORD'] = os.environ.get('MYSQL_DATABASE_PASSWORD')
app.config['MYSQL_DATABASE_DB'] = os.environ.get('DB_NAME')
app.config['MYSQL_DATABASE_HOST'] = os.environ.get('DB_HOST') #'34.73.152.50'

mysql.init_app(app)
conn = mysql.connect()
cursor = conn.cursor()

# Generate routes
@app.route('/')
def home():
	cursor.execute('SELECT greeting from website')
	greeting = cursor.fetchone()
	return render_template('home.html', greeting=greeting)

@app.route('/blog')
def blog():
	cursor.execute('SELECT title from blog')
	blog_posts = cursor.fetchall()
	return render_template('blog.html', blog_posts=blog_posts)


@app.route('/health-check')
def health_check():
	return "success"

# Testing prior to refactor
if __name__ == "__main__":
	app.run(host='0.0.0.0', debug=True)