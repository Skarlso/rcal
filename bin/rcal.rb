#!/usr/bin/env ruby

require 'thor'
require 'rcal'

class RCalCli < Thor
  def initialize(*args)
    super
    @rcal = RCal::RCal.new
  end

  desc 'show MONTH YEAR', 'Shows the calendar.'
  def show(month, year)
    @rcal.show_calendar(month, year)
  end

  desc 'day', 'Shows breakdown of today.'
  def day
    @rcal.day
  end

  desc 'week', 'Shows breakdown of this week.'
  def week
    @rcal.week
  end

  desc 'month', 'Shows breakdown of this month.'
  def month
    @rcal.month
  end
end

RCalCli.start
