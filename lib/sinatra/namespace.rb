module Sinatra
  module Namespace
    module InstanceMethods
      def url_to(uri, *args)
        url(path_to(uri), *args)
      end

      def redirect_to(uri, *args)
        redirect(path_to(uri) *args)
      end

      def path_to(uri)
        "#{namespace_prefix}#{uri}"
      end

      private

      def namespace_prefix
        pattern = Mustermann.new(@namespace.pattern)
        keys = pattern.names
        pattern_params = params.select {|key| keys.include? key }

        pattern.expand(pattern_params)
      end
    end
  end
end
