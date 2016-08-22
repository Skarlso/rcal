#!/usr/bin/env ruby

require 'thor'
require 'rcal'

class RCalCli < Thor
  desc 'show MONTH YEAR', 'Shows the calendar.'
  def show(month, year)
    rcal = RCal.new
    rcal.show_calendar(month, year)
  end

  desc 'today', 'Shows breakdown of today.'
  def today
    puts color_shell.set_color('Test this sh*t.', :red, :bold)
  end

  private

  def color_shell
    Thor::Shell::Color.new
  end
end

RCalCli.start
