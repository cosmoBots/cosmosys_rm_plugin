class CosmosysBaselinesController < ApplicationController

  def index
  	@cosmosys_baselines = CosmosysBaseline.all
  end

  def execute
    baseline = CosmosysBaseline.find(params[:id])
    #result = exec("pwd")    
    result = system("python plugins/cosmosys/assets/javascripts/#{baseline.name}.py")
    baseline.execute()
    flash[:notice] = "Baseline ejecutada con mensaje #{params[:mensaje]}"
    redirect_to :action => 'index'  	
  end
end
