class Utterson < Sinatra::Application
    get '/hyde/sites' do
        @sites = Site.all
        erb :'hyde/list'
    end

    get '/hyde/create' do
        erb :'hyde/create'
    end

    post '/hyde/create' do
        site = Site.new
        site.id = params['name']
        redirect "/site/#{site.id}" if site.create
        erb :'hyde/create', :locals => { :errors => site.error_messages }
    end
end
