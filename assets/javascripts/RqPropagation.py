#!/usr/bin/env python
# coding: utf-8

# In[ ]:


# get_ipython().run_line_magic('run', './RqValidation.ipynb')
from RqValidation import *

# In[ ]:


def propagate_maturity(rq,mat_st,mat_lev):
    # Actualizamos el estado del requisito
    print("rq:",rq)
    print("this_rq_st: ",rq.status.name)
    this_rq_mat_lev = req_status_maturity[rq.status.name]
    print("this_rq_mat_lev: ",this_rq_mat_lev)
    print("mat_lev:", mat_lev)
    if (mat_lev<this_rq_mat_lev):
        # Nos toca propagar el cambio
        redmine.issue.update(resource_id=rq.id,
                             status_id = mat_st)        
        # Propagaremos el cambio a aquellas relaciones dependientes de madurez superior
        rel = redmine.issue_relation.filter(issue_id=rq.id)
        rel_filt = list(filter(lambda x: x.issue_to_id != rq.id, rel))
        if (len(rel_filt)>0):
            for r in rel_filt:
                req_to_change = redmine.issue.get(r.issue_to_id)
                propagate_maturity(req_to_change,mat_st,mat_lev)

    

for e in result_list:
    if (e['type'] == 'dependency'):
        mat = (e['dependable'])['status_maturity']
        dependent_id = e['dependent']['id']
        print(dependent_id)
        maturity_str = req_maturity_propagation[mat]
        st_list = redmine.issue_status.all()
        status_to_set = None
        for st in st_list:
            if (st.name == maturity_str):
                print(st.name)
                status_to_set = st
                
        if status_to_set is not None:
            print("Propagamos: ",dependent_id, " ", status_to_set.id)
            req_to_change = redmine.issue.get(dependent_id)
            propagate_maturity(req_to_change,status_to_set.id, mat)
            print("Acabamos con ",e)
        else:
            print("ERROR, no pudimos encontrar el estado")
        

print("Acabamos!!!")


# In[ ]:





# In[ ]:




