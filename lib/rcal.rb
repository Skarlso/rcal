require 'yaml'

module RCal
  class RCal
    def initialize
      @config = YAML.load_file(File.join(__dir__, 'config.yaml'))
    end

    def show_calendar(month, year)
      p @config
      puts month, year
    end
  end
end
