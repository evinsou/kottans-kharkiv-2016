require 'holidays'
require 'holidays/core_extensions/date'

class Date
  include Holidays::CoreExtensions::Date
end

class BusnessDays
  include Enumerable

  def initialize(start: Date.today, region: :ca)
    @region = region
    @dates = (start..Float::INFINITY).lazy
  end

  def each(&block)
    return to_enum unless block_given?

    loop do
      d = @dates.next
      next if day_off?(d, @region)

      block.call(d)
    end

    self.lazy
  end

  private

  def day_off?(date, region)
    date.holiday?(region) || weekend?(date)
  end

  def weekend?(date)
    [6, 7].include?(date.wday)
  end
end

busiday = BusnessDays.new(start: Date.parse('2016-05-01'), region: :fr).lazy
busidays_wo_fridays = busiday.reject { |d| d.wday == 5 }
busi_5_days = busiday.reject { |d| d.wday == 5 }.take(5)
puts busiday.class
puts busidays_wo_fridays.class
puts busi_5_days

busi_5_days.each do |day|
  puts day.to_s
end
