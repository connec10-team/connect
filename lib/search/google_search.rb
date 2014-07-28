require 'net/http'

module Search
  class GoogleSearch
    def initialize()
    end

    def open(word, start_index)
      @word = word
      @display_data = Array.new
      search(word, start_index)
    end

    def next
      search(@word, @start_index)
    end

    def output
      @display_data
    end

    private
    def search(word, start_index)
      url = "https://www.googleapis.com/customsearch/v1"
      value = "?key=#{GOOGLE_API_KEY}&cx=#{GOOGLE_SEARCH_ID}&q=#{word}&start=#{start_index}"
      api_url = URI(url+value)
      request_get = Net::HTTP.get(api_url)
      data = JSON.parse(request_get)
      data["queries"]["nextPage"].each do |i|
        @start_index = i["startIndex"]
      end
      data["items"].each do |item|
        c = Hash.new
        c[:title] = item["title"]
        c[:link] = item["link"]
        c[:snippet] = item["snippet"]
        @display_data.push(c)
      end
    end
  end
end
