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
      events = calendar(bd.strftime(TIME_FORMAT), ed.strftime(TIME_FORMAT))
      events.each do |e|
        puts ' -------------------'
        puts "Starts: #{e.start.date_time.strftime('%Y-%m-%d  %H:%M:%S')}"
        puts color_shell.set_color("|     #{e.summary}     |", @config.busy)
        puts "Ends: #{e.end.date_time.strftime('%Y-%m-%d  %H:%M:%S')}" unless e.end_time_unspecified
        puts ' -------------------'
      end
    end

    def week
      bd = Time.now
      ed = bd + (60 * 60 * 24 * 7)
      events = calendar(bd.strftime(TIME_FORMAT), ed.strftime(TIME_FORMAT))
      events.each do |e|
        puts ' -------------------'
        puts "Starts: #{e.start.date_time.strftime('%Y-%m-%d  %H:%M:%S')}" unless e.start.date_time.nil?
        puts color_shell.set_color("|     #{e.summary}     |", @config.busy)
        puts "Ends: #{e.end.date_time.strftime('%Y-%m-%d  %H:%M:%S')}" unless e.end.date_time.nil?
        puts ' -------------------'
      end
    end

    def month
      bd = Time.now
      ed = bd + (60 * 60 * 24)
      puts color_shell.set_color(calendar(bd.iso8601, ed.iso8601), @config.busy)
    end

    private

    def calendar(begin_date, end_date)
      calendar = Calendar::CalendarService.new
      calendar.authorization = @credentials
      events = Queue.new
      threads = []

      all_calendar_ids.each do |calendar_id|
        threads << Thread.new do
          response = calendar.list_events(calendar_id,
                                          single_events: true,
                                          order_by: 'startTime',
                                          time_min: begin_date,
                                          time_max: end_date)
          response.items.each { |i| events << i }
        end
      end
      threads.each(&:join)
      events.size.times.with_object([]) { |_, o| o << events.pop }
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
