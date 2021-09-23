#!/bin/python3

from celery import Celery
app = Celery('addTask', broker='amqp://guest@localhost//')
@app.task
def add(x, y):
    return x + y
