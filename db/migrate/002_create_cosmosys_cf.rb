		# Trackers
include Redmine::I18n
 class CreateCosmosysCf < ActiveRecord::Migration[5.2]
	def up
		rqtrck = Tracker.find_by_name('Req')
		rqdoctrck = Tracker.find_by_name('ReqDoc')
		custom_field = IssueCustomField.create!(:name => 'RqTitle', 
			:field_format => 'string', :searchable => true,
			:is_for_all => true, :tracker_ids => [rqtrck.id, rqdoctrck.id])

	    rqtypefield = IssueCustomField.create!(:name => 'RqType', 
	    	:field_format => 'list', :possible_values => ['Info', 'Complex',
	    		'Opt','Mech','Hw','Sw'], 
	    		:is_filter => true,
	    		:is_for_all => true, :tracker_ids => [rqtrck.id, rqdoctrck.id])


'''RqType	List				 Delete
	RqSources	Text				 Delete
	RqLevel	List				 Delete
	RqRationale	Text				 Delete
	RqUnitary?	Boolean				 Delete
	RqComplete?	Boolean				 Delete
	RqConsistent?	Boolean				 Delete
	RqAtomic?	Boolean				 Delete
	RqTraceable?	Boolean				 Delete
	RqCurrent?	Boolean				 Delete
	RqUnambiguous?	Boolean				 Delete
	RqSpcImportant	Boolean				 Delete
	RqVerifiable?
	Title	Text				 Delete
	ChapterNumber	Text				 Delete
	RqValue	Text				 Delete
	RqVar	Text				 Delete
	Prefix		
	'''	
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
	end
end
