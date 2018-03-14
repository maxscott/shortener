require 'uri'

class Url < ApplicationRecord
  validates_presence_of :original_url
  validate :valid_url
  before_save :assign_unique_short_url

  def valid_url
    url = URI.parse(self.original_url)

    unless
      url.kind_of?(URI::HTTP) || url.kind_of?(URI::HTTPS)
      errors.add(:invalid_url_error, "You can't do that what are you, crazy?")
    end
  end

  def assign_unique_short_url
    chars = ['0'..'9','A'..'Z','a'..'z'].map{|r| r.to_a}.flatten
    loop do
      self.short_url = 5.times.map{ chars.sample }.join
      break if Url.find_by_short_url(self.short_url).nil?
    end
  end
end
