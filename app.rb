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

    [200, headers, TimeFormatter.new(@received_format).call]

  rescue RuntimeError => e
    [400, headers, [e.message]]
  end
end
