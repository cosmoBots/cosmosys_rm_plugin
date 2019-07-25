class CreateCosmosysBaselines < ActiveRecord::Migration[5.2]
  def change
    create_table :cosmosys_baselines do |t|
      t.string :name
      t.integer :project_id
      t.integer :user_id
    end
    CosmosysBaseline.create(:name => "RqCreatePrj")
    CosmosysBaseline.create(:name => "RqUpload")
    CosmosysBaseline.create(:name => "RqReports")
    CosmosysBaseline.create(:name => "RqValidation")
    CosmosysBaseline.create(:name => "RqPropagation")
    CosmosysBaseline.create(:name => "RqDownload")
    CosmosysBaseline.create(:name => "RqImportDoorstop")
    CosmosysBaseline.create(:name => "RqExportDoorstop")
    CosmosysBaseline.create(:name => "RqTree")
    
    rm = Role.find_by_name('RqMngr')
    rm.add_permission!(:view_cosmosys)
    rm.add_permission!(:execute_cosmosys)
    rm.add_permission!(:tree_cosmosys)
    rm.save

    rw = Role.find_by_name('RqWriter')
    rw.add_permission!(:view_cosmosys)
    rw.add_permission!(:execute_cosmosys)
    rw.add_permission!(:tree_cosmosys)
    rw.save

    rr = Role.find_by_name('RqReviewer')
    rr.add_permission!(:view_cosmosys)
    rr.add_permission!(:execute_cosmosys)
    rr.add_permission!(:tree_cosmosys)
    rr.save

   end
end
