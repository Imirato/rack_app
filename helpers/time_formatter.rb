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

  attr_reader :success, :formatted_time, :unknown_time_formats

  def call
    if acceptable_format?
      @success = true
      @formatted_time = received_format_conversion
    else
      @success = false
    end
  end

  private

  def acceptable_format?
    invalid_formats.empty?
  end

  def invalid_formats
    @unknown_time_formats ||= @received_format - ACCEPTABLE_FORMAT.keys.map(&:to_s)
  end

  def received_format_conversion
    conversion_time = @received_format.map do |t|
      ACCEPTABLE_FORMAT[t.to_sym]
    end.join('-')

    Time.now.strftime(conversion_time)
  end
end
