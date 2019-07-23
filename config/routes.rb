# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
get 'cosmosys_baselines', :to => 'cosmosys_baselines#index'
post 'cosmosys_baselines/:id/execute', :to => 'cosmosys_baselines#execute'