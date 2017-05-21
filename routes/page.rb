class Utterson < Sinatra::Application
    with_site do
        get '/page/list' do
            erb :'page/list'
        end
    end
end
