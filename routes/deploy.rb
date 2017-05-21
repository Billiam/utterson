class Utterson < Sinatra::Application
    with_site do
        get '/deploy' do
            erb :'deploy/list', :locals => { :site => current_site }
        end

        get '/deploy/to/:environment' do
            site = current_site
            redirect_to '/deploy' if site.config['utterson_deploy'][ params[:environment] ].nil?
            erb :'deploy/confirm', :locals => { :site => site }
        end

        post '/deploy/to/:environment/confirmed' do
            site = current_site
            redirect_to '/deploy' if site.config['utterson_deploy'][ params[:environment] ].nil?
            deploy = site.deploy( params[:environment] )
            erb :'deploy/deployed', :locals => { :site => site, :deploy => deploy }
        end
    end
end
