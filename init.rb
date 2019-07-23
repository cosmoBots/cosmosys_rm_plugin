Redmine::Plugin.register :cosmosys do
  name 'Cosmosys plugin'
  author 'cosmoBots.eu'
  description 'Plugin to adapt Redmine to be the backend of cosmoSys'
  version '0.0.2'
  url 'http://cosmobots.eu/projects/cosmosys'
  author_url 'http://cosmobots.eu'

  #menu :application_menu, :cosmosys_baselines, { :controller => 'cosmosys_baselines', :action => 'index' }, :caption => 'cosmoSys'  
end
