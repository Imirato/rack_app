require_relative 'helpers/time_formatter'

class App
  def call(env)
    @query = env['QUERY_STRING']
    @path = env['REQUEST_PATH']
    @received_format = (Rack::Utils.parse_nested_query(@query)).values.join.split(',')

    response
  end

  private

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def response
    return [404, headers, ['Not Found']] if @path != '/time'

    time_formatter = TimeFormatter.new(@received_format)
    time_formatter.call

    if time_formatter.success
      [200, headers, [time_formatter.formatted_time]]
    else
      [400, headers, ["Unknown time format #{time_formatter.unknown_time_formats}"]]
    end
  end
end
