class App

  ACCEPTABLE_FORMAT = %w[year month day hour minute second].freeze

  def call(env)
    @query = env['QUERY_STRING']
    @path = env['REQUEST_PATH']
    @received_format = (Rack::Utils.parse_nested_query(@query)).values.join.split(',')

    [status, headers, body]
  end

  private

  def status
    if @path == '/time' && acceptable_format?
      200
    elsif @path == '/time'
      400
    else
      404
    end
  end

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def body
    if @path == '/time' && acceptable_format?
      [received_format_conversion]
    elsif @path == '/time'
      ["Unknown time format #{unknown_time_format}"]
    else
      ['Not Found']
    end
  end

  def acceptable_format?
    (@received_format - ACCEPTABLE_FORMAT).empty?
  end

  def unknown_time_format
    @received_format - ACCEPTABLE_FORMAT
  end

  def received_format_conversion
    @received_format.map do |t|
      case t
      when 'year'
        Time.now.year
      when 'month'
        Time.now.month
      when 'day'
        Time.now.day
      when 'hour'
        Time.now.hour
      when 'minute'
        Time.now.min
      when 'second'
        Time.now.sec
      end
    end.join('-')
  end
end
