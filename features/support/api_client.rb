module ApiAutomation
  class ApiClient
    include HTTParty

    DEFAULT_HEADERS = {
      "Accept" => "application/json",
      "Content-Type" => "application/json"
    }.freeze

    attr_reader :base_url, :headers

    def initialize(base_url:, headers: {})
      @base_url = base_url.to_s.sub(%r{/*\z}, "")
      @headers = DEFAULT_HEADERS.merge(headers)
    end

    def get(path, query: {}, headers: {})
      request(:get, path, query: query, headers: headers)
    end

    def post(path, body: nil, headers: {})
      request(:post, path, body: body, headers: headers)
    end

    def put(path, body: nil, headers: {})
      request(:put, path, body: body, headers: headers)
    end

    def patch(path, body: nil, headers: {})
      request(:patch, path, body: body, headers: headers)
    end

    def delete(path, headers: {})
      request(:delete, path, headers: headers)
    end

    private

    def request(method, path, query: {}, body: nil, headers: {})
      self.class.public_send(
        method,
        url_for(path),
        query: query,
        body: serialize_body(body),
        headers: @headers.merge(headers)
      )
    end

    def url_for(path)
      normalized_path = path.to_s.start_with?("/") ? path : "/#{path}"
      "#{base_url}#{normalized_path}"
    end

    def serialize_body(body)
      return nil if body.nil?
      return body if body.is_a?(String)

      JSON.generate(body)
    end
  end
end
