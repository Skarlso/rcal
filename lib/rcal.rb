require 'yaml'
require 'rcal/auth'
require 'google/apis/calendar_v3'
require 'date'
require 'thor'

module RCal
  class RCal
    def initialize
      @config = YAML.load_file(File.join(__dir__, '../cfg/config.yaml'))
      @credentials = AuthModule.new(@config['store']).credentials
    end

    def show_calendar(month, year)
      puts month, year
    end

    def day
      puts color_shell.set_color(calendar(Time.now.iso8601, 1), :red)
    end

    def week
    end

    def month
    end

    private

    def calendar(date, max_results)
      calendar = Google::Apis::CalendarV3::CalendarService.new
      calendar.authorization = @credentials
      calendar_id = 'primary'
      response = calendar.list_events(calendar_id,
                                      max_results: max_results,
                                      single_events: true,
                                      order_by: 'startTime',
                                      time_min: date)
      response.items.each { |i| p i.summary }
      response
    end

    def color_shell
      Thor::Shell::Color.new
    end
  end
end
