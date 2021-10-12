import os
from flask import Flask, request, jsonify, render_template
from prometheus_flask_exporter import PrometheusMetrics
import mysql.connector

app = Flask(__name__)
metrics = PrometheusMetrics(app)

# static information as metric
metrics.info('app_info', 'Application info', version='0.1.0')

# Define any needed dependencies/classes
class DBManager:
    def __init__(self, database='blog', host=os.getenv('DB_HOST'), user="root", password_file="password.txt"):
        pf = open(password_file, 'r')
        self.connection = mysql.connector.connect(
            user=user, 
            password=pf.read(),
            host=host,
            database=database,
            auth_plugin='mysql_native_password'
        )
        pf.close()
        self.cursor = self.connection.cursor()
    
    def populate_db(self):
        # create the main website data, as needed (future use)
        self.cursor.execute('DROP TABLE IF EXISTS website')
        self.cursor.execute('CREATE TABLE website (id INT AUTO_INCREMENT PRIMARY KEY, greeting VARCHAR(255))')
        self.cursor.execute('''INSERT INTO website (id, greeting) VALUES (1, 'Hello World')''')
        # create some sample data, blog entries in this case
        self.cursor.execute('DROP TABLE IF EXISTS blog')
        self.cursor.execute('CREATE TABLE blog (id INT AUTO_INCREMENT PRIMARY KEY, title VARCHAR(255))')
        self.cursor.executemany('INSERT INTO blog (id, title) VALUES (%s, %s);', [(i, 'Blog post #%d'% i) for i in range (1,5)])
        self.connection.commit()
    
    def query_titles(self):
        self.cursor.execute('SELECT title FROM blog')
        rec = []
        for c in self.cursor:
            rec.append(c[0])
        return rec

# Begin Flask routes
conn = None

@app.route('/')
def home():
	return render_template('home.html')

@app.route('/blog')
def blog():
    global conn
    if not conn:
        conn = DBManager(password_file='password.txt')
        conn.populate_db()

    blog_posts = conn.query_titles()
    return render_template('blog.html',blog_posts=blog_posts)

@app.route('/health-check')
def health_check():
	return "success"

# Testing prior to refactor
if __name__ == "__main__":
    app.run(host='0.0.0.0', debug=True)