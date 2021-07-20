# spec/support/request_spec_helper
module JsonSpecHelper
  # Parse JSON response to ruby hash
  def json_list
    json = Oj.load(response.body, symbol_keys: true)

    expect(json).to have_key(:data)
    
    data = json[:data].map {|hash| 
      hash.each_pair { |key, value| 
        if key == :id 
          hash[key] = value.to_i
        end
      }
    }
    data
  end

  def json_single
    json = Oj.load(response.body, symbol_keys: true)

    expect(json).to have_key(:data)

    data = json[:data].each_pair { |key, value| 
      if key == :id 
        json[:data][key] = value.to_i
      end
    }
    data
  end

  def errors
    json = Oj.load(response.body, symbol_keys: true)
    json[:messages]
  end
end