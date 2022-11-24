class TimeFormatter
  ACCEPTABLE_FORMAT = {
    year: '%Y',
    month: '%m',
    day: '%d',
    hour: '%H',
    minute: '%M',
    second: '%S'
  }.freeze

  def initialize(received_format)
    @received_format = received_format
  end

  def call
    raise "Unknown time format #{unknown_time_format}" unless acceptable_format?

    [received_format_conversion]
  end

  private

  def acceptable_format?
    unknown_time_format.empty?
  end

  def unknown_time_format
    @received_format - ACCEPTABLE_FORMAT.keys.map(&:to_s)
  end

  def received_format_conversion
    conversion_time = @received_format.map do |t|
      ACCEPTABLE_FORMAT[t.to_sym]
    end.join('-')

    Time.now.strftime(conversion_time)
  end
end
