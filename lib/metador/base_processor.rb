module Metador
  class BaseProcessor
    attr_reader :config

    def initialize(config)
      @config = config
    end
  end
end