
include Redmine::I18n
 class CreateCosmosysCf < ActiveRecord::Migration[5.2]
	def up
		# Trackers
		rqtrck = Tracker.find_by_name('Req')
		rqdoctrck = Tracker.find_by_name('ReqDoc')

		# Custom fields
		rqtitlefield = IssueCustomField.create!(:name => 'RqTitle', 
			:field_format => 'string', :searchable => true,
			:is_for_all => true, :tracker_ids => [rqtrck.id, rqdoctrck.id])

		rqtypefield = IssueCustomField.create!(:name => 'RqType', 
	    		:field_format => 'list', :possible_values => ['Info', 'Complex',
	    		'Opt','Mech','Hw','Sw'], 
	    		:is_filter => true,
	    		:is_for_all => true, :tracker_ids => [rqtrck.id])

		rqlevelfield = IssueCustomField.create!(:name => 'RqLevel', 
	    		:field_format => 'list', :possible_values => ['None', 'System',
	    		'Derived','External','Shared'], 
	    		:is_filter => true,
	    		:is_for_all => true, :tracker_ids => [rqtrck.id])

		rqrationalefield = IssueCustomField.create!(:name => 'RqRationale', 
			:field_format => 'text',
			:description => 'Diagrams of Hierarchy and Dependence',
			:min_length => '', :max_length => '', :regexp => '',
			:default_value => '', :is_required => false, 
			:is_filter => false, :searchable => true, 
			:visible => true, :role_ids => [],
			:full_width_layout => true, :text_formatting => "full",
			:is_for_all => true, :tracker_ids => [rqtrck.id])

		rqsrcfield = IssueCustomField.create!(:name => 'RqSources', 
			:field_format => 'string', :searchable => true,
			:is_for_all => true, :tracker_ids => [rqtrck.id])

		rqchapterfield = IssueCustomField.create!(:name => 'RqChapter', 
			:field_format => 'string', :searchable => false,
			:is_for_all => true, :tracker_ids => [rqtrck.id, rqdoctrck.id])

		rqvarfield = IssueCustomField.create!(:name => 'RqVar', 
			:field_format => 'string', :searchable => true,
			:is_for_all => true, :tracker_ids => [rqtrck.id])

		rqvaluefield = IssueCustomField.create!(:name => 'RqValue', 
			:field_format => 'string', :searchable => true,
			:is_for_all => true, :tracker_ids => [rqtrck.id])

		rqprefixfield = IssueCustomField.create!(:name => 'RqPrefix', 
			:field_format => 'string', :searchable => false,
			:is_for_all => true, :tracker_ids => [rqdoctrck.id])

=begin
Not imported yet
	RqUnitary?	Boolean				 Delete
	RqComplete?	Boolean				 Delete
	RqConsistent?	Boolean				 Delete
	RqAtomic?	Boolean				 Delete
	RqTraceable?	Boolean				 Delete
	RqCurrent?	Boolean				 Delete
	RqUnambiguous?	Boolean				 Delete
	RqSpcImportant	Boolean				 Delete
	RqVerifiable?
=end
	end

	def down
		tmp = IssueCustomField.find_by_name('RqTitle')
		if (tmp != nil) then
			tmp.destroy
		end
		tmp = IssueCustomField.find_by_name('RqType')
		if (tmp != nil) then
			tmp.destroy
		end
		tmp = IssueCustomField.find_by_name('RqLevel')
		if (tmp != nil) then
			tmp.destroy
		end
		tmp = IssueCustomField.find_by_name('RqRationale')
		if (tmp != nil) then
			tmp.destroy
		end
		tmp = IssueCustomField.find_by_name('RqSources')
		if (tmp != nil) then
			tmp.destroy
		end
		tmp = IssueCustomField.find_by_name('RqChapter')
		if (tmp != nil) then
			tmp.destroy
		end
		tmp = IssueCustomField.find_by_name('RqVar')
		if (tmp != nil) then
			tmp.destroy
		end
		tmp = IssueCustomField.find_by_name('RqValue')
		if (tmp != nil) then
			tmp.destroy
		end
		tmp = IssueCustomField.find_by_name('RqPrefix')
		if (tmp != nil) then
			tmp.destroy
		end
	end
end
