#!/usr/bin/env python
# coding: utf-8

# In[ ]:


from cfg.configfile_req import *
from redminelib import Redmine

redmine = Redmine(req_server_url,key=req_key_txt)
projects = redmine.project.all()
prj_present = False
for p in projects:
    if (p.identifier == req_project_id_str):
        print ("!!!ERROR, EL PROYECTO YA EXISTE!!!",req_project_id_str)
        prj_present = True
        


# In[ ]:


if not prj_present:  
    print("Crearemos el proyecto ",req_project_id_str)
    project = redmine.project.create(
        name = req_project_id_str,
        identifier = req_project_id_str,
        description = req_project_id_str)
#...     tracker_ids=[1, 2],
#...     issue_custom_field_ids=[1, 2],
#...     custom_fields=[{'id': 1, 'value': 'foo'}, {'id': 2, 'value': 'bar'}],
#...     enabled_module_names=['calendar', 'documents', 'files', 'gantt']


# In[ ]:


from lib.csysrq_support import *

from cfg.configfile_req import *
prj_present = False
print("Hago algo")

if not prj_present:
    copy_dir("./plugins/cosmosys/assets/javascripts/prj_template",cfg_homedir + "/repos/"+req_project_id_str)
    print("El path para configurar el repositorio de tu proyecto en redmine es: ",cfg_homedir + "/repos/"+req_project_id_str)
    print("El lugar para configurarlo es ",req_server_url+"/projects/"+req_project_id_str+"/repositories/new")
    print("---- Valores ---")
    print("SCM = Filesystem ")
    print("Identifier = rq ")
    print("Root directory = ",cfg_homedir + "/repos/"+req_project_id_str)
    print("---- Y pulsar save ----")
    print("Podrás comprobar si funciona yendo a ",req_server_url+"/projects/"+req_project_id_str+"/repository/rq")
    print("Acabamos")
else:
    print("!!!ERROR, EL PROYECTO YA EXISTE!!!",req_project_id_str)


# In[ ]:




