class Utterson < Sinatra::Application
    with_site do
      get '' do
          posts = Post.all( current_site.id )
          erb :'post/list', :locals => { :posts => posts }
      end

      get '/post/create' do
          post = Post.new
          erb :'post/create', :locals => { :site => current_site, :post => post }
      end

      post '/post/create' do
          site = current_site
          post = Post.new
          post.settings['title'] = params['title'].strip
          post.settings['published'] = params['published'].strip
          post.settings['layout'] = params['layout'].strip
          post.settings['date'] = params['date'].strip
          post.content = params['content']
          if post.create( site.id, params['name'].strip.downcase.gsub(' ', '-') )
              Commandline.git_add( site.id, post.git_filename, 'Creating post: ' + post.id.shellescape )
              redirect_to '/post/edit/' + post.id + '?created=true'
          end
          erb :'post/create', :locals => { :site => site, :post => post }
      end

      get '/post/edit/:id' do
          site = current_site
          post = Post.get( site_id, params['id'] )
          erb :'post/edit', :locals => { :site => site, :post => post }
      end

      post '/post/edit/:id' do
          site = current_site
          post = Post.get( site_id, params['id'] )
          post.settings['title'] = params['title'].strip
          post.settings['published'] = params['published'].strip
          post.settings['layout'] = params['layout'].strip
          post.settings['date'] = params['date'].strip
          post.content = params['content']
          if post.save
              Commandline.git_add( site.id, post.git_filename , 'Updating post: ' + post.id.shellescape )
          end
          erb :'post/edit', :locals => { :site => site, :post => post }
      end

      get '/post/categories/:id' do
          site = current_site
          post = Post.get( site_id, params['id'] )
          erb :'post/categories', :locals => { :site => site, :post => post }
      end

      post '/post/categories/:id' do
          site = current_site
          post = Post.get( site_id, params['id'] )
          case params['action']
          when 'add'
              params['categories'].each do |category|
                  post.settings['categories'] << category
              end
          when 'create'
              post.settings['categories'] << params['category'].strip
          when 'remove'
              params['categories'].each do |category|
                  post.settings['categories'].delete(category)
              end
          end
          if post.save
              Commandline.git_add( site.id, post.git_filename , 'Updating categories for post: ' + post.id.shellescape )
          end
          erb :'post/categories', :locals => { :site => site, :post => post }
      end

      get '/post/delete/:id' do
          site = current_site
          post = Post.get( site_id, params['id'] )
          erb :'post/delete', :locals => { :site => site, :post => post }
      end

      post '/post/delete/:id' do
          site = current_site
          post = Post.get( site_id, params['id'] )
          Commandline.git_rm( site.id, post.git_filename, 'Deleting post: ' + post.id.shellescape )
          erb :'post/delete', :locals => { :site => site, :post => post }
      end
    end
end
