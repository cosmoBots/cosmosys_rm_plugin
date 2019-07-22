class CreateCosmosysDiagramsCf < ActiveRecord::Migration[5.2]
	def up
		link_str = "link"
		diagrams_pattern = "$$d $$h"
		prj_diagram_pattern = "$$d $$h"


		# Trackers
		rqtrck = Tracker.find_by_name('Req')
		rqdoctrck = Tracker.find_by_name('ReqDoc')

		# Issue part
		# Create diagrams custom fields
		rqdiagramsfield = IssueCustomField.create!(:name => 'RqDiagrams', 
			:field_format => 'text',
			:description => 'Diagrams of Hierarchy and Dependence',
			:min_length => '', :max_length => '', :regexp => '',
			:default_value => diagrams_pattern, 
			:is_required => false, 
			:is_filter => false, :searchable => false, 
			:visible => true, :role_ids => [],
			:full_width_layout => true, :text_formatting => "full",
			:is_for_all => true, :tracker_ids => [rqtrck.id, rqdoctrck.id]
		)

		rqhiediaglink = IssueCustomField.create!(:name => 'RqHierarchyDiagram',
			:field_format => 'link', :description => "A link to the Hierarchy Diagram",
			:url_pattern => "/projects/%project_identifier%/repository/rq/raw/reporting/doc/img/%id%_h.gv.svg",
			:default_value => link_str,
			:is_for_all => true, :tracker_ids => [rqtrck.id, rqdoctrck.id])

		rqdepdiaglink = IssueCustomField.create!(:name => 'RqDependenceDiagram',
			:field_format => 'link', :description => "A link to the Dependence Diagram",
			:url_pattern => "/projects/%project_identifier%/repository/rq/raw/reporting/doc/img/%id%_d.gv.svg",
			:default_value => link_str,
			:is_for_all => true, :tracker_ids => [rqtrck.id, rqdoctrck.id])

		# Project part
		# Create diagrams custom fields
		rqprjdiagramsfield = ProjectCustomField.create!(:name => 'RqDiagrams', 
			:field_format => 'text',
			:description => 'Diagrams of Hierarchy and Dependence',
			:min_length => '', :max_length => '', :regexp => '',
			:default_value => prj_diagram_pattern, 
			:is_required => false, 
			:is_filter => false, :searchable => false, 
			:visible => true, :role_ids => [],
			:full_width_layout => true, :text_formatting => "full"
		)

		rqprjhiediaglink = ProjectCustomField.create!(:name => 'RqHierarchyDiagram',
			:field_format => 'link', :description => "A link to the Hierarchy Diagram",
			:url_pattern => "/projects/%project_identifier%/repository/rq/raw/reporting/doc/img/%project_identifier%_h.gv.svg",
			:default_value => link_str)

		rqprjdepdiaglink = ProjectCustomField.create!(:name => 'RqDependenceDiagram',
			:field_format => 'link', :description => "A link to the Dependence Diagram",
			:url_pattern => "/projects/%project_identifier%/repository/rq/raw/reporting/doc/img/%project_identifier%_d.gv.svg",
			:default_value => link_str)


		Issue.find_each{|i|
			if i.tracker == rqtrck or i.tracker == rqdoctrck then
				foundhie = false
				founddep = false
				founddiag = false
				i.custom_values.each{|cf|
					if cf.custom_field_id == rqhiediaglink.id then
						foundhie = true
						cf.value = link_str
						cf.save
					end
					if cf.custom_field_id == rqdepdiaglink.id then
						founddep = true
						cf.value = link_str
						cf.save
					end
					if cf.custom_field_id == rqdiagramsfield.id then
						founddiag = true
						cf.value = diagrams_pattern
						cf.save
					end
				}
				if not foundhie then
					icv = CustomValue.new
					icv.custom_field = rqhiediaglink
					icv.customized = i
					icv.value = link_str
					icv.save
				end
				if not founddep then
					icv = CustomValue.new
					icv.custom_field = rqdepdiaglink
					icv.customized = i
					icv.value = link_str
					icv.save
				end
				if not founddiag then
					icv = CustomValue.new
					icv.custom_field = rqdiagramsfield
					icv.customized = i
					icv.value = diagrams_pattern
					icv.save
				end				
			end
		}
		Project.find_each{|i|
			foundhie = false
			founddep = false
			founddiag = false
			i.custom_values.each{|cf|
				if cf.custom_field_id == rqprjhiediaglink.id then
					foundhie = true
					cf.value = link_str
					cf.save
				end
				if cf.custom_field_id == rqprjdepdiaglink.id then
					founddep = true
					cf.value = link_str
					cf.save
				end
				if cf.custom_field_id == rqprjdiagramsfield.id then
					founddiag = true
					cf.value = prj_diagram_pattern
					cf.save
				end

			}
			if not foundhie then
				icv = CustomValue.new
				icv.custom_field = rqprjhiediaglink
				icv.customized = i
				icv.value = link_str
				icv.save
			end
			if not founddep then
				icv = CustomValue.new
				icv.custom_field = rqprjdepdiaglink
				icv.customized = i
				icv.value = link_str
				icv.save
			end
			if not founddiag then
				icv = CustomValue.new
				icv.custom_field = rqprjdiagramsfield
				icv.customized = i
				icv.value = prj_diagram_pattern
				icv.save
			end
		}

	end

	def down
		# Issue part
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
		# Project part
		tmp = ProjectCustomField.find_by_name('RqDiagrams')
		if (tmp != nil) then
			tmp.destroy
		end
		tmp = ProjectCustomField.find_by_name('RqHierarchyDiagram')
		if (tmp != nil) then
			tmp.destroy
		end
		tmp = ProjectCustomField.find_by_name('RqDependenceDiagram')
		if (tmp != nil) then
			tmp.destroy
		end
	end
end
