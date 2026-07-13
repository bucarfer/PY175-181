from flask import Flask, render_template, redirect, url_for
import yaml 

app = Flask(__name__)

with open("users.yaml", "r") as file:
    users = yaml.safe_load(file)

def total_interests(users):
    return sum(len(user['interests']) for user in users.values())

@app.route('/')
def home():
    return redirect(url_for('users_list'))

@app.route("/users")
def users_list():
    return render_template('users.html',
                           users=users,
                           total_users=len(users),
                           total_interests=total_interests(users))

@app.route("/user/<user_name>")
def user_profile(user_name):
    user = users.get(user_name)
    if not user:
        return redirect(url_for('users_list'))
    return render_template('user.html',
                           user_name=user_name,
                           user=user,
                           users=users,
                           total_users=len(users),
                           total_interests=total_interests(users))

if __name__ == '__main__':
    app.run(debug=True, port=5003)