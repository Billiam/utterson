require 'rubygems'
require 'bundler/setup'
require 'tilt/erb'
require 'open3'
require 'shellwords'

Bundler.require(:default)

class Utterson < Sinatra::Application
    register Sinatra::Namespace

    set :sites_dir, 'sites/'

    def self.with_site(&block)
        namespace '/site/:site_id' do
            before do
                @site_id = params[:site_id]
            end

            instance_eval(&block)
        end
    end

    def site_id
        @site_id
    end

    def current_site
        @current_site ||= Site.get site_id if site_id
    end

    get '/' do
        redirect '/hyde/sites'
    end
end

%w(lib models routes).each do |directory|
    Dir["./#{directory}/**/*.rb"].each { |file| require file }
end
