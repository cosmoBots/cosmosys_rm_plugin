class CosmosysBaselinesController < ApplicationController
  before_action :find_project#, :authorize, :only => [:index,:execute]
  
  def index
  	@cosmosys_baselines = CosmosysBaseline.all
    #@polls = Poll.find(:all) # @project.polls    
  end

  def structure_node(node_vector, parent_node)
      node_vector.each{|node|
        my_issue = Issue.find(node['id'])
        if (parent_node != nil) then
          my_issue.parent_issue = parent_node
        end
        node['children'].each{|c|
          structure_node(c,my_issue)
        }
      } 
  end

  def tree
    require 'json'

    structure_str = params[:structure]
    print(structure_str)
    structure = JSON.parse(structure_str)
    structure_node(structure,nil)
  end

  def execute
    print("\n\n\n\n\n\n")
    if request.get? then
      print("GET!!!!!")
    else
      print("POST!!!!!")
    end
    baseline = CosmosysBaseline.find(params[:id])
    if (params[:node_id]) then
      print("NODO!!!\n")
      comando = "python plugins/cosmosys/assets/javascripts/#{baseline.name}.py #{params[:node_id]}"
    else
      comando = "python plugins/cosmosys/assets/javascripts/#{baseline.name}.py #{@project.identifier}"
    end
    # result = system("pwd")
    # result = system(comando)
=begin    
    output = `#{comando}`
    p output
=end
    require 'open3'
    require 'json'

    stdin, stdout, stderr = Open3.popen3("#{comando}")
    stdout.each do |ele|
      print ("ELE"+ele+"\n")
      @output = ele
      if (baseline.name == 'RqTree') then
        @jsonoutput = JSON.parse(ele)
      else
        @jsonoutput = nil
      end
    end
    respond_to do |format|
      format.html {
        if @output.size <= 100 then 
          flash[:notice] = "Baseline #{params[:comando]} ejecutada con mensaje:\n" + @output.to_s
        else
          flash[:notice] = "Baseline #{params[:comando]} ejecutada con mensaje muy largo\n"
        end
        redirect_to :action => 'index', params: request.query_parameters and return
      }
      format.json { 
        if (baseline.name == 'RqTree') then
          require 'json'
          ActiveSupport.escape_html_entities_in_json = false
          render json: @jsonoutput
          ActiveSupport.escape_html_entities_in_json = true        
        end
      }
    end
    baseline.execute()
  end

  def find_project
    # @project variable must be set before calling the authorize filter
    if (params[:node_id]) then
      @issue = Issue.find(params[:node_id])
      @project = @issue.project
    else
      @project = Project.find(params[:project_id])
    end
  end
end
