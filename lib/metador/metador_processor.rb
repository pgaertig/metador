module Metador
  class MetadorProcessor

    pattr_initialize :config, :subprocessors

    def self.build(config)
      new(
          config,
          [
              QueryProcessor.build(config),
              WebHookProcessor.build(config)
          ]
      )
    end

    def process(data)
      time = Benchmark.realtime do
        subprocessors.each do |p|
          p.process(data) if p.accepts?(data)
        end
      end
      (data[:_debug]||={})[:process_time] = time
      data
    end

    def accepts?(data)
      data #Non nil object
    end
  end
end