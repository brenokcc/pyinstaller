# -*- coding: utf-8 -*-

import os
import json
import shutil
import zipfile
import subprocess
from sys import platform
from urllib import request

# http://meuabstract.com.br/media/helloworld.zip

# get app url
if platform == "linux" or platform == "linux2":
    url = input("Nome: ")
elif platform == "darwin":
    p = subprocess.Popen(['osascript', '-e', 'display dialog "Informe o endereço da aplicação" default answer ""'], stdout=subprocess.PIPE)
    url = p.communicate()[0].decode().strip().split('text returned:')[1]
elif platform == "win32":
    if os.path.exists("url.txt"):
        os.unlink("url.txt")
    p = subprocess.Popen(["input.exe"])
    p.communicate()
    f = open("url.txt")
    url = f.readline().strip()
    f.close()

# download app
f = request.urlopen(url)
data = f.read()
f.close()

name = url.split("/")[-1].split('.')[0]
home = os.path.expanduser("~")
app_path = os.path.join(home, name)
zip_path = "{}.zip".format(app_path)
json_path = "{}/setup.json".format(app_path)
python_path = platform == "win32" and os.path.join(app_path, "python.exe") or 'python'
pythonw_path = platform == "win32" and os.path.join(app_path, "pythonw.exe") or 'pythonw'

f = open(zip_path, "w+b")
f.write(data)
f.close()

# extract app
with zipfile.ZipFile(zip_path, "r") as zip_ref:
    zip_ref.extractall(home)
os.unlink(zip_path)

# move python files
if platform == "win32":
    current_path = os.path.realpath(os.path.dirname(__file__))
    files = os.listdir(current_path)
    for f in files:
        src = os.path.join(current_path, f)
        dest = os.path.join(app_path, f)
        if not os.path.exists(dest):
            print(src, dest, os.path.isfile(src))
            if os.path.isfile(src):
                shutil.copy(src, dest)
            else:
                shutil.copytree(src, dest)

# install dependecies and run
if os.path.exists(json_path):
    setup = json.load(open(json_path))
    for requirement in setup.get("requires", []):
        p = subprocess.Popen(
            [pythonw_path, "-m", "pip", "install", requirement, "--no-warn-script-location"],
            cwd=app_path)
        p.communicate()
    run = setup.get("run")
    if run:
        p = subprocess.Popen([pythonw_path, run], cwd=app_path)
