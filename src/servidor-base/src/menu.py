# -*- coding: utf-8 -*-
#! /usr/bin/python3

import os
import yaml
import getch


class color:
   PURPLE = '\033[95m'
   CYAN = '\033[96m'
   DARKCYAN = '\033[36m'
   BLUE = '\033[94m'
   GREEN = '\033[92m'
   YELLOW = '\033[93m'
   RED = '\033[91m'
   BOLD = '\033[1m'
   UNDERLINE = '\033[4m'
   END = '\033[0m'


defaults = ["dns", "dhcpd","inverse_proxy" ] 
options = {}
selected = []
def getInfo(data):
    for serv in data["services"]:
        options[serv] = {
                "show": True if serv not in defaults else False, 
                "activate": False if serv not in defaults else True, 
                "deps" : data["services"][serv]["depends_on"] if "depends_on" in  data["services"][serv].keys() else [], 
                }
    for serv in data["services"]:
        for dep in  options[serv]["deps"]:
            options[dep]["show"]=False
    return options
            
def getOptions(info):
    opt = []
    for serv in info:
        if info[serv]["show"]:
            opt.append(serv)
    return opt


def showOptionMenu(opts):
    print("\n"+color.BOLD+color.YELLOW+ 'choisissez les services souhaités: ' + color.END+"\n")
    for opt in range(1,len(opts)+1):
        if not selected[opt-1]:
            print("    ["+str(opt)+"] - "+opts[opt-1])
        else:
            print('    '+color.BOLD+color.GREEN+"[" + str(opt)+"] - "+opts[opt-1] + color.END)
    
    print(color.BOLD+"\n     "+color.UNDERLINE+"Appuyez sur Entrée pour confirmer la sélection."+color.END)
    

def confirmServices(selected, opts):
    for opt in range(0,len(opts)):
        if selected[opt]:
            info[opts[opt]]["activate"] = True
            for dep in info[opts[opt]]["deps"]:
                 info[dep]["activate"] = True
    for o in info:
        if not info[o]["activate"]:
            del data["services"][o]
    with open('./docker-compose.yml', 'w') as file:
        documents = yaml.dump(data, file)

with open("./all-services-compose.yml","r") as file:
    try:
        data = yaml.safe_load(file)
        info = getInfo(data)
    except yaml.YAMLError as exc:
        print(exc)

opts = getOptions(info);
for i in opts:
    selected.append(False) 
key = ord(" ")
while key != ord("q"):
    os.system("clear")    
    showOptionMenu(opts)
    try:
        key = ord(getch.getch())
        
    except:
        continue
    if key-48 in range(1,len(opts)+1):
        selected[int(chr(key))-1] = not selected[int(chr(key))-1] 
    elif key == 10 or chr(key) == "C":
        confirmServices(selected, opts)
        break
