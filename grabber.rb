require 'net/http'
require 'json'
require 'highline/import'


def yesno(prompt = 'Continue?', default = true)
  a = ''
  s = default ? '[Y/n]' : '[y/N]'
  d = default ? 'y' : 'n'
  until %w[y n].include? a
    a = ask("#{prompt} #{s} ") { |q| q.limit = 1; q.case = :downcase }
    a = d if a.length == 0
  end
  a == 'y'
end

class Grabber
  attr_accessor :save_location

  APPLE_URL = "http://a1.phobos.apple.com/us/r1000/000/Features/atv/AutumnResources/videos/entries.json"

  def initialize
    @save_location = "."
  end
  
  def download_json
    uri = URI(APPLE_URL)
    response = Net::HTTP.get(uri)
    @json = JSON.parse(response)
  end
  
  def download_files
    @json.each do |item|
      puts "Looking at #{item['id']}"
      video_index = item['assets']
      video_index.each do |video|
        puts "  Found #{video['id']}, place: #{video['accessibilityLabel']}, #{video['timeOfDay']}time"
        puts yesno ("Download?")
      end
    end
  end

end
