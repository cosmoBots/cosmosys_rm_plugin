#!/usr/bin/env python
# coding: utf-8

# In[ ]:


from cfg.configfile_req import *
from redminelib import Redmine

print(req_server_url)
print(req_key_txt)
print(req_project_id_str)
redmine = Redmine(req_server_url,key=req_key_txt)
projects = redmine.project.all()

print("Proyectos:")
for p in projects:
    print ("\t",p.identifier," \t| ",p.name)

my_project = redmine.project.get(req_project_id_str)
print ("Obtenemos proyecto: ",my_project.identifier," | ",my_project.name)    

# get_ipython().run_line_magic('run', './RqConnectNList.ipynb')
tmp = redmine.issue.filter(project_id=req_project_id_str, tracker_id=req_rq_tracker_id)
my_project_issues = sorted(tmp, key=lambda k: k.custom_fields.get(req_chapter_cf_id).value)
tmp = redmine.issue.filter(project_id=req_project_id_str, tracker_id=req_doc_tracker_id)
my_doc_issues = sorted(tmp, key=lambda k: k.custom_fields.get(req_chapter_cf_id).value)


# Ahora recorremos el proyecto y sacamos los diagramas completos de jerarquía y dependencias, y guardamos los ficheros de esos diagramas en la carpeta doc.

# In[ ]:


# Preparamos el fichero JSON que usaremos de puente para el resultado

result_list = []

def parent_child_validation(i,results):
    # Exploro los hijos
    for c in i.children:
        child_issue = redmine.issue.get(c.id)
        if (req_status_maturity[child_issue.status.name] < req_status_maturity[i.status.name]):
            print("\n\n**************")
            print(i.id,": ",i.subject,": ",i.status,":",req_status_maturity[i.status.name])
            print("\t* ",child_issue.id,": ",child_issue.subject,": ",child_issue.status,":",req_status_maturity[child_issue.status.name])
            print("xxxxxxxxxxxx: Error.  el requisito hijo está en estado ",child_issue.status," mientras su requisito padre está en estado ",i.status)
            thiserror = {
                'type':'hyerarchy',
                'parent':{
                    'id': i.id,
                    'subject': i.subject,
                    'status': i.status.name,
                    'status_maturity': req_status_maturity[i.status.name],
                },
                'child':{
                    'id': child_issue.id,
                    'subject': child_issue.subject,
                    'status': child_issue.status.name,
                    'status_maturity': req_status_maturity[child_issue.status.name],
                },
            }
            results.append(thiserror)



def dependence_validation(i,results):            
    # Exploro las relaciones
    my_issue_relations = redmine.issue_relation.filter(issue_id=i.id)
    my_filtered_issue_relations = list(filter(lambda x: x.issue_to_id != i.id, my_issue_relations))
    if (len(my_issue_relations)>0):
        for r in my_filtered_issue_relations:
            rel_issue = redmine.issue.get(r.issue_to_id)
            if (req_status_maturity[rel_issue.status.name] > req_status_maturity[i.status.name]):
                print("\n\n**************")
                print(i.id,": ",i.subject,": ",i.status,":",req_status_maturity[i.status.name])
                print("\t-",r.relation_type,"-> ",rel_issue.subject," : ",rel_issue.status,":",req_status_maturity[rel_issue.status.name])
                print("xxxxxxxxxxxx: Error.  el requisito dependiente está en estado ",rel_issue.status," mientras el requisito del que depende está en estado ",i.status)
                thiserror = {
                    'type':'dependency',
                    'dependable':{
                        'id': i.id,
                        'subject': i.subject,
                        'status': i.status.name,
                        'status_maturity': req_status_maturity[i.status.name],
                    },
                    'dependent':{
                        'id': rel_issue.id,
                        'subject': rel_issue.subject,
                        'status': rel_issue.status.name,
                        'status_maturity': req_status_maturity[rel_issue.status.name],
                    },
                }
                results.append(thiserror)

for issue in my_project_issues:
    dependence_validation(issue,result_list)
    parent_child_validation(issue,result_list)


# In[ ]:


import json

# Preparamos el fichero JSON que usaremos de puente para el resultado
  
with open('./RqValidation-Result.json', 'w') as outfile:  
    json.dump(result_list, outfile)


# In[ ]:


for e in result_list:
    print(e)
print("Acabamos")


# In[ ]:




