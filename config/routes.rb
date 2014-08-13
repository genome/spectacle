Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  root 'search#overview', as: 'search_overview'

  get 'analysis_projects/:id' => 'analysis_projects#overview', as: 'analysis_project_overview'
  get 'analysis_projects/:id/timeline' => 'timelines#analysis_project', as: 'analysis_project_timeline'
  get 'analysis_projects/:id/failed_instrument_data' => 'analysis_projects#failed_instrument_data', as: 'analysis_project_failed_instrument_data'
  get 'models/:id' => 'models#status', as: 'model_status'
  get 'models' => 'models#overview', as: 'model_overview'
  get 'model_groups/coverage/:id' => 'model_groups#coverage', as: 'model_group_coverage'
  get 'model_groups/:id' => 'model_groups#overview', as: 'model_group_overview'
  get 'builds/:id' => 'builds#status', as: 'build_status'
  get 'processing_profiles/:id' => 'processing_profiles#overview', as: 'processing_profile_overview'
  get 'software_results/:id' => 'software_results#overview', as: 'software_result_overview'
  get 'subjects/:id' => 'subjects#overview', as: 'subject_overview'
  get 'libraries/:id' => 'libraries#overview', as: 'library_overview'
  get '/search' => 'search#results', as: 'search_results'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
