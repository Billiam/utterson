class Utterson < Sinatra::Application
    with_site do
        get '/configuration' do
            erb :'site/config', :locals => { :site => current_site }
        end

        post '/configuration' do
            site = current_site
            site.update_config( params )
            if site.save
                Commandline.git_add( site.id, site.git_config_filename , 'Updating config' )
            end
            erb :'site/config', :locals => { :site => site }
        end

        get '/rename' do
            erb :'site/rename', :locals => { :site => current_site }
        end

        post '/rename' do
            site = current_site
            redirect "/site/#{site.id}/rename"if site.rename( params['siteid'] )
            erb :'site/rename', :locals => { :site => site }
        end
    end
end
