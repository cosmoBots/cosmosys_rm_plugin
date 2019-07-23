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
   end
end
