class CreateCosmosysDiagramsCf < ActiveRecord::Migration[5.2]
	def up
		# Trackers
		rqtrck = Tracker.find_by_name('Req')
		rqdoctrck = Tracker.find_by_name('ReqDoc')

		# Create diagrams custom fields
		rqdiagramsfield = IssueCustomField.create!(:name => 'RqDiagrams', 
			:field_format => 'text',
			:description => 'Diagrams of Hierarchy and Dependence',
			:min_length => '', :max_length => '', :regexp => '',
			:default_value => '', :is_required => false, 
			:is_filter => false, :searchable => false, 
			:visible => true, :role_ids => [],
			:full_width_layout => true, :text_formatting => "full",
			:is_for_all => true, :tracker_ids => [rqtrck.id, rqdoctrck.id]
		)

		rqhiediaglink = IssueCustomField.create!(:name => 'RqHierarchyDiagram',
			:field_format => 'link', :description => "A link to the Hierarchy Diagram",
			:url_pattern => "/projects/%project_identifier%/repository/rq/raw/reporting/doc/img/%id%_h.gv.svg",
			:default_value => 'link', :is_computed => false,
			:is_for_all => true, :tracker_ids => [rqtrck.id, rqdoctrck.id])

		rqdepdiaglink = IssueCustomField.create!(:name => 'RqDependenceDiagram',
			:field_format => 'link', :description => "A link to the Dependence Diagram",
			:url_pattern => "/projects/%project_identifier%/repository/rq/raw/reporting/doc/img/%id%_d.gv.svg",
			:default_value => 'link', :is_computed => false,
			:is_for_all => true, :tracker_ids => [rqtrck.id, rqdoctrck.id])

		Issue.find_each{|i|
			if i.tracker == rqtrck or i.tracker == rqdoctrck then
				foundhie = false
				founddep = false
				i.custom_values.each{|cf|
					if cf.custom_field_id == rqhiediaglink.id then
						foundhie = true
						cf.value = 'link'
						cf.save
					end
					if cf.custom_field_id == rqdepdiaglink.id then
						founddep = true
						cf.value = 'link'
						cf.save
					end
				}
				if not foundhie then
					icv = CustomValue.new
					icv.custom_field = rqhiediaglink
					icv.customized = i
					icv.value = 'link'
					icv.save
				end
				if not founddep then
					icv = CustomValue.new
					icv.custom_field = rqdepdiaglink
					icv.customized = i
					icv.value = 'link'
					icv.save
				end
			end
		}

	end

	def down
		tmp = IssueCustomField.find_by_name('RqDiagrams')
		if (tmp != nil) then
			tmp.destroy
		end
		tmp = IssueCustomField.find_by_name('RqHierarchyDiagram')
		if (tmp != nil) then
			tmp.destroy
		end
		tmp = IssueCustomField.find_by_name('RqDependenceDiagram')
		if (tmp != nil) then
			tmp.destroy
		end		
	end
end
