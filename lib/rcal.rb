require 'yaml'
require 'rcal/auth'
require 'google/apis/calendar_v3'
require 'thor'
require 'time'

module RCal
  class RCal
    Config = Struct.new(:busy, :bd)
    Calendar = Google::Apis::CalendarV3
    TIME_FORMAT = '%Y-%m-%dT%H:%M:%S%:z'.freeze

    def initialize
      @config = YAML.load_file(File.join(__dir__, '../cfg/config.yaml'))
      @credentials = AuthModule.new(@config['store']).credentials
      setup_colors
    end

    def setup_colors
      @config = Config.new(@config['color_scheme']['busy'].to_sym,
                           @config['color_scheme']['birthday'].to_sym)
    end

    def show_calendar(month, year)
      puts month, year
    end

    def day
      now = Time.now
      bd = Time.new(now.year, now.month, now.day, 0, 0, 0, now.strftime('%:z'))
      ed = bd + (60 * 60 * 24)
      puts color_shell.set_color(calendar(bd.strftime(TIME_FORMAT), ed.strftime(TIME_FORMAT)), @config.busy)
    end

    def week
      bd = Time.now
      ed = bd + (60 * 60 * 24 * 7)
      puts color_shell.set_color(calendar(bd.iso8601, ed.iso8601), @config.busy)
    end

    def month
      bd = Time.now
      ed = bd + (60 * 60 * 24)
      puts color_shell.set_color(calendar(bd.iso8601, ed.iso8601), @config.busy)
    end

    private

    def calendar(begin_date, end_date)
      # lock = Mutex.new
      calendar = Calendar::CalendarService.new
      calendar.authorization = @credentials
      # this is semi thread safe because it's only adding values.
      events = []
      threads = []

      all_calendar_ids.each do |calendar_id|
        threads << Thread.new do
          response = calendar.list_events(calendar_id,
                                          single_events: true,
                                          order_by: 'startTime',
                                          time_min: begin_date,
                                          time_max: end_date)
          response.items.each { |i| events << i.summary }
        end
      end
      threads.each(&:join)
      events
    end

    def all_calendar_ids
      calendar = Calendar::CalendarService.new
      calendar.authorization = @credentials
      calendar.list_calendar_lists.items.each_with_object([]) { |i, o| o << i.id }
    end

    def color_shell
      Thor::Shell::Color.new
    end
  end
end
