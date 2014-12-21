require 'yaml'
require 'pry'

class User

  attr_reader :username, :domain

  def self.all
    build(records)
  end

  def self.domain_exists?(domain)
    all.any? { |user| user[:domain] == domain }
  end

  def initialize(username, domain)
    @username = username
    @domain = domain
  end

  def first_name
    @username.split(' ').first.downcase
  end

  def last_name
    @username.split(' ').last.downcase
  end

  private

  #
  # the purpose of this methos is to provide a more readable
  # represenation of the initiale data structure.
  #
  def self.build(users)
    users.map{|h| {name: h.keys[0], domain: h.values[0]}}
  end

  def self.records
    YAML.load_file('config/db.yml')[:users]
  end
end
