module ApiAutomation
  module World
    attr_accessor :api_client, :last_response, :request_body, :request_headers

    def configured_base_url
      ENV.fetch("BASE_API_URL") do
        raise "BASE_API_URL is missing. Copy .env.example to .env and set BASE_API_URL."
      end
    end

    def request_body_from_file(file_name)
      fixtures_dir = File.expand_path("../fixtures/request_bodies", __dir__)
      fixture_path = File.expand_path(file_name, fixtures_dir)

      unless fixture_path.start_with?("#{fixtures_dir}#{File::SEPARATOR}")
        raise "Request body fixture must be inside #{fixtures_dir}"
      end

      JSON.parse(File.read(fixture_path))
    rescue Errno::ENOENT
      raise "Request body fixture not found: #{fixture_path}"
    end

    def headers_for_request
      request_headers || {}
    end

    def parsed_response_body
      JSON.parse(last_response.body)
    rescue JSON::ParserError
      last_response.body
    end

    def value_at_path(data, path)
      path.to_s.split(".").reduce(data) do |current, key|
        case current
        when Hash
          current.fetch(key)
        when Array
          current.fetch(Integer(key))
        else
          raise KeyError, "Cannot read '#{key}' from #{current.class}"
        end
      end
    end
  end
end
