from cfg.configfile_req import *
from redminelib import Redmine
import json
import sys


def update_tree(issue_vector,parent_id,parent_chapter):
	index = 1
	for c in issue_vector:
		rqchapter = parent_chapter+'.'+str(index)
		index += 1
		my_child = redmine.issue.get(c['id'])
		print("La issue ",my_child.id," pasa a ser hija de ", parent_id)
		print("con capítulo ",rqchapter)
		redmine.issue.update(resource_id=my_child.id, 
			parent_issue_id = parent_id,
            custom_fields = [
	                          {'id': req_chapter_cf_id, 'value':rqchapter}
	                        ]
		)

		update_tree(c['children'],my_child.id,rqchapter)


if len(sys.argv)>1:
    my_file = sys.argv[1]

redmine = Redmine(req_server_url,key=req_key_txt)

treedata = []
filename = my_file

with open(filename, 'r') as inputfile:  
    treedata = json.load(inputfile)

for t in treedata:
	my_id = int(t['id'])
	my_issue = redmine.issue.get(my_id)
	my_chapter = my_issue.custom_fields.get(req_chapter_cf_id).value
	update_tree(t['children'],my_id,my_chapter)

