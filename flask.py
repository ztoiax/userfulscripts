#!/bin/python3

from flask import Flask
app = Flask(__name__)

app.config['DEBUG'] = True


@app.route('/')
def hello_world():
    return '<h1>泥豪，世界！</h1>\
        <img src="https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2700654223,2122220372&fm=26&gp=0.jpg"> \
        <img src="https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=350647292,841711&fm=27&gp=0.jpg"> \
        <img src="https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=4121236200,1201346551&fm=27&gp=0.jpg">'


if __name__ == "__main__":
    app.run(host='127.0.0.1', port=5000)
