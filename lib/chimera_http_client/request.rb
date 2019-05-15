module ChimeraHttpClient
  class Request
    TIMEOUT_SECONDS = 3

    def initialize(logger: nil)
      @logger = logger
    end

    def run(url:, method:, body: nil, options: {}, headers: {})
      create(url: url, method: method, body: body, options: options, headers: headers).run

      @result
    end

    def create(url:, method:, body: nil, options: {}, headers: {})
      request_params = {
        method:          method,
        body:            body,
        params:          options[:params] || {},
        headers:         headers,
        timeout:         options[:timeout] || TIMEOUT_SECONDS,
        accept_encoding: "gzip",
        cache:           options[:cache],
      }

      # Basic-auth support:
      username = options.fetch(:username, nil)
      password = options.fetch(:password, nil)
      request_params[:userpwd] = "#{username}:#{password}" if username && password

      request = Typhoeus::Request.new(url, request_params)

      @result = nil
      request.on_complete do |response|
        @logger&.info("Completed HTTP request: #{method.upcase} #{url} " \
          "in #{response.total_time&.round(3)}sec with status code #{response.code}")

        @result = on_complete_handler(response)
      end

      @logger&.info("Starting HTTP request: #{method.upcase} #{url}")

      request
    end

    private

    def on_complete_handler(response)
      return Response.new(response) if response.success?

      exception_for(response)
    end

    def exception_for(response)
      return TimeoutError.new(response) if response.timed_out?

      case response.code.to_i
      when 301, 302, 303, 307
        RedirectionError.new(response)
      when 200..399
        nil
      when 400
        BadRequestError.new(response)
      when 401
        UnauthorizedError.new(response)
      when 403
        ForbiddenError.new(response)
      when 404
        NotFoundError.new(response)
      when 405
        MethodNotAllowedError.new(response)
      when 409
        ResourceConflictError.new(response)
      when 422
        UnprocessableEntityError.new(response)
      when 400..499
        ClientError.new(response)
      when 500..599
        ServerError.new(response)
      else # response.code.zero?
        ConnectionError.new(response)
      end
    end
  end
end
