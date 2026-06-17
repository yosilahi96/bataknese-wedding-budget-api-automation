module ApiAutomation
  module World
    attr_accessor :api_client, :last_response

    def configured_base_url
      ENV.fetch("BASE_API_URL") do
        raise "BASE_API_URL is missing. Copy .env.example to .env and set BASE_API_URL."
      end
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
