include Redmine::I18n
 class CreateCosmosys < ActiveRecord::Migration[5.2]
	def up

		# Roles
		manager = Role.create! :name => 'RqMngr',
                               :issues_visibility => 'all',
                               :users_visibility => 'all'
		manager.permissions = manager.setable_permissions.collect {|p| p.name}
		manager.save!

		writer = Role.create!  :name => 'RqWriter',
                                  :permissions => [:manage_versions,
                                                  :manage_categories,
                                                  :view_issues,
                                                  :add_issues,
                                                  :edit_issues,
                                                  :view_private_notes,
                                                  :set_notes_private,
                                                  :manage_issue_relations,
                                                  :manage_subtasks,
                                                  :add_issue_notes,
                                                  :save_queries,
                                                  :view_documents,
                                                  :view_wiki_pages,
                                                  :view_wiki_edits,
                                                  :edit_wiki_pages,
                                                  :delete_wiki_pages,
                                                  :view_files,
                                                  :manage_files,
                                                  :browse_repository,
                                                  :view_changesets,
                                                  :commit_access,
                                                  :manage_related_issues]

		reviewer = Role.create! :name => 'RqReviewer',
                                :permissions => [:view_issues,
                                                :add_issue_notes,
                                                :save_queries,
                                                :view_documents,
                                                :view_wiki_pages,
                                                :view_wiki_edits,
                                                :view_files,
                                                :browse_repository,
                                                :view_changesets]

		developer = Role.create! :name => 'RqDev',
                                :permissions => [:view_issues,
                                                :add_issue_notes,
                                                :save_queries,
                                                :view_documents,
                                                :view_wiki_pages,
                                                :view_wiki_edits,
                                                :view_files,
                                                :browse_repository,
                                                :view_changesets]

		tester = Role.create! :name => 'RqTest',
                                :permissions => [:view_issues,
                                                :add_issue_notes,
                                                :save_queries,
                                                :view_documents,
                                                :view_wiki_pages,
                                                :view_wiki_edits,
                                                :view_files,
                                                :browse_repository,
                                                :view_changesets]

		# Statuses
		stdraft = IssueStatus.create!(:name => 'RqDraft', :is_closed => false)
		ststable = IssueStatus.create!(:name => 'RqStable', :is_closed => false)
		stapproved = IssueStatus.create!(:name => 'RqApproved', :is_closed => false)
		stincluded = IssueStatus.create!(:name => 'RqIncluded', :is_closed => false)
		stvalidated = IssueStatus.create!(:name => 'RqValidated', :is_closed => true)
		strejected = IssueStatus.create!(:name => 'RqRejected', :is_closed => false)
		sterased = IssueStatus.create!(:name => 'RqErased', :is_closed => true)
		stzombie = IssueStatus.create!(:name => 'RqZombie', :is_closed => true)

		rqstatuses = [stdraft, ststable, stapproved, stincluded, stvalidated, 
			strejected, sterased, stzombie]

		# Trackers
		rqtrck = Tracker.create!(:name => 'Req',    
			:default_status_id => stdraft.id, 
			:is_in_chlog => true,  :is_in_roadmap => true)
		rqdoctrck = Tracker.create!(:name => 'ReqDoc', 
			:default_status_id => stdraft.id, 
			:is_in_chlog => true, :is_in_roadmap => true)

		trackers = [rqtrck, rqdoctrck]

		trackers.each{|t|
		
			# Writer transitions
		       	WorkflowTransition.create!(:tracker_id => t.id,
		       		:role_id => writer.id, :old_status_id => stdraft.id, 
		       		:new_status_id => ststable.id)
		       	WorkflowTransition.create!(:tracker_id => t.id,
		       		:role_id => writer.id, :old_status_id => stdraft.id, 
		       		:new_status_id => sterased.id)
		       	WorkflowTransition.create!(:tracker_id => t.id,
		       		:role_id => writer.id, :old_status_id => stdraft.id, 
		       		:new_status_id => stzombie.id)
		       	WorkflowTransition.create!(:tracker_id => t.id,
		       		:role_id => writer.id, :old_status_id => ststable.id, 
		       		:new_status_id => stdraft.id)
		       	WorkflowTransition.create!(:tracker_id => t.id,
		       		:role_id => writer.id, :old_status_id => stzombie.id, 
		       		:new_status_id => stdraft.id)
		       	WorkflowTransition.create!(:tracker_id => t.id,
		       		:role_id => writer.id, :old_status_id => stapproved.id, 
		       		:new_status_id => stdraft.id)
		       	WorkflowTransition.create!(:tracker_id => t.id,
		       		:role_id => writer.id, :old_status_id => strejected.id, 
		       		:new_status_id => sterased.id)
		       	WorkflowTransition.create!(:tracker_id => t.id,
		       		:role_id => writer.id, :old_status_id => strejected.id, 
		       		:new_status_id => stdraft.id)
		       	WorkflowTransition.create!(:tracker_id => t.id,
		       		:role_id => writer.id, :old_status_id => stvalidated.id, 
		       		:new_status_id => stdraft.id)
		       	WorkflowTransition.create!(:tracker_id => t.id,
		       		:role_id => writer.id, :old_status_id => stincluded.id, 
		       		:new_status_id => stdraft.id)


			# Reviewer transitions
		       	WorkflowTransition.create!(:tracker_id => t.id,
		       		:role_id => reviewer.id, :old_status_id => ststable.id, 
		       		:new_status_id => stapproved.id)
		       	WorkflowTransition.create!(:tracker_id => t.id,
		       		:role_id => reviewer.id, :old_status_id => ststable.id, 
		       		:new_status_id => strejected.id)

			# Developer transitions
		       	WorkflowTransition.create!(:tracker_id => t.id,
		       		:role_id => developer.id, :old_status_id => stapproved.id, 
		       		:new_status_id => stincluded.id)
		       	WorkflowTransition.create!(:tracker_id => t.id,
		       		:role_id => developer.id, :old_status_id => stincluded.id, 
		       		:new_status_id => stapproved.id)

			# Reviewer transitions
		       	WorkflowTransition.create!(:tracker_id => t.id,
		       		:role_id => tester.id, :old_status_id => stincluded.id, 
		       		:new_status_id => stvalidated.id)
		       	WorkflowTransition.create!(:tracker_id => t.id,
		       		:role_id => tester.id, :old_status_id => stvalidated.id, 
		       		:new_status_id => stincluded.id)

			# Manager transitions
			rqstatuses.each { |os|
				rqstatuses.each { |ns|
					WorkflowTransition.create!(:tracker_id => t.id, 
						:role_id => manager.id, 
						:old_status_id => os.id, 
						:new_status_id => ns.id) unless os == ns
				}
			}
		}

	end

	def down
		rqtrck = Tracker.find_by_name('Req')
		rqdoctrck = Tracker.find_by_name('ReqDoc')
		# Trackers
		if (rqtrck != nil) then
			WorkflowTransition.all.each{ |tr|
				if (tr.tracker == rqtrck) then
					tr.destroy
				end
			}
			rqtrck.destroy
		end
		if (rqdoctrck != nil) then
			WorkflowTransition.all.each{ |tr|
				if (tr.tracker == rqdoctrck) then
					tr.destroy
				end
			}
			rqdoctrck.destroy
		end
		tmp = IssueStatus.find_by_name('RqDraft')
		if (tmp != nil) then
			tmp.destroy
		end
		tmp = IssueStatus.find_by_name('RqStable')
		if (tmp != nil) then
			tmp.destroy
		end
		tmp = IssueStatus.find_by_name('RqApproved')
		if (tmp != nil) then
			tmp.destroy
		end
		tmp = IssueStatus.find_by_name('RqIncluded')
		if (tmp != nil) then
			tmp.destroy
		end
		tmp = IssueStatus.find_by_name('RqValidated')
		if (tmp != nil) then
			tmp.destroy
		end
		tmp = IssueStatus.find_by_name('RqRejected')
		if (tmp != nil) then
			tmp.destroy
		end
		tmp = IssueStatus.find_by_name('RqErased')
		if (tmp != nil) then
			tmp.destroy
		end
		tmp = IssueStatus.find_by_name('RqZombie')
		if (tmp != nil) then
			tmp.destroy
		end

		# Roles
		tmp = Role.find_by_name('RqWriter')
		if (tmp != nil) then
			tmp.destroy
		end
		tmp = Role.find_by_name('RqReviewer')
		if (tmp != nil) then
			tmp.destroy
		end
		tmp = Role.find_by_name('RqMngr')
		if (tmp != nil) then
			tmp.destroy
		end
		tmp = Role.find_by_name('RqDev')
		if (tmp != nil) then
			tmp.destroy
		end
		tmp = Role.find_by_name('RqTest')
		if (tmp != nil) then
			tmp.destroy
		end

	end
end
