require 'yaml'

class User

  def self.all
    build(records)
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

User.all