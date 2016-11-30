module Administrate
  class Namespace
    def initialize(namespace)
      @namespace = namespace
    end

    def resources
      namespace_controller_paths.uniq.map do |path|
        Resource.new(namespace, path)
      end
    end

    private

    attr_reader :namespace

    def namespace_controller_paths
      all_controller_paths.select do |controller|
        controller.starts_with?(namespace.to_s)
      end
    end

    def all_controller_paths
      Rails.application.routes.routes.map do |route|
        route.defaults[:controller].to_s
      end
    end

    class Resource
      attr_reader :namespace, :resource

      def initialize(namespace, resource)
        @namespace = namespace
        @resource = resource
      end

      def to_s
        name.to_s
      end

      def to_sym
        name
      end

      def name
        resource.to_s.gsub(/^#{namespace}\//, "").to_sym
      end

      def path
        name.to_s.gsub("/", "_")
      end
    end
  end
end
