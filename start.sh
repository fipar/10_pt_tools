#!/bin/bash
# simple script you can use to host the presentation
# once running, just load http://localhost:8080/Presenter.html
# (or use whatever port you set)
port={1:-8080}
python -m SimpleHTTPServer 8080
