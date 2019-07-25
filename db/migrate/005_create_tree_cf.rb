class CreateCosmosysTreeCf < ActiveRecord::Migration[5.2]
	def up
		link_str = "link"
		url_pattern = "/cosmosys_baselines/9/execute?id=%id%"

		# Trackers
		rqtrck = Tracker.find_by_name('Req')
		rqdoctrck = Tracker.find_by_name('ReqDoc')

		# Issue part
		# Create diagrams custom fields
		rqhiediaglink = IssueCustomField.create!(:name => 'RqTree',
			:field_format => 'link', :description => "A link to the Tree JSON file",
			:url_pattern => url_pattern,
			:default_value => link_str,
			:is_for_all => true, :tracker_ids => [rqtrck.id, rqdoctrck.id])

		Issue.find_each{|i|
			if i.tracker == rqtrck or i.tracker == rqdoctrck then
				foundhie = false
				i.custom_values.each{|cf|
					if cf.custom_field_id == rqhiediaglink.id then
						foundhie = true
						cf.value = link_str
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
			end
		}

	end

	def down
		# Issue part
		tmp = IssueCustomField.find_by_name('RqTree')
		if (tmp != nil) then
			tmp.destroy
		end
	end
end
