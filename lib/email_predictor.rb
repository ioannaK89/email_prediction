require_relative 'models/user'

class EmailPredictor

  attr_reader :username, :domain

  def initialize(username, domain)
    @username = username
    @domain = domain
  end

  def predict
    validate!

    User.domain_exists?(@domain) ? find_prediction_for_domain : all_predictions
  end

  private

  def find_prediction_for_domain
    user_from_db = User.find_by_domain(@domain)

    prediction = case user_from_db.email
                 when /^\w\.\w@#{@domain}$/i
                   first_initial_dot_last_initial
                 when /^\w{2,}\.\w@#{@domain}$/i
                   first_name_dot_last_initial
                 when /^\w\.\w{2,}@#{@domain}$/i
                   first_initial_dot_last_name
                 when /^\w{2,}\.\w{2,}@#{@domain}$/i
                   first_name_dot_last_name
                 end

    "#{prediction}@#{@domain}"
  end

  def all_predictions
    [
      first_name_dot_last_name,
      first_name_dot_last_initial,
      first_initial_dot_last_name,
      first_initial_dot_last_initial
    ].map{|name| "#{name}@#{@domain}"}
  end

  def user
    @user ||= User.new(@username)
  end

  def first_name_dot_last_name
    "#{user.first_name}.#{user.last_name}"
  end

  def first_name_dot_last_initial
    "#{user.first_name}.#{user.last_name[0]}"
  end

  def first_initial_dot_last_name
    "#{user.first_name[0]}.#{user.last_name}"
  end

  def first_initial_dot_last_initial
    "#{user.first_name[0]}.#{user.last_name[0]}"
  end

  def validate!
    raise 'Missing username' if @username.nil?
    raise 'Missing domain' if @domain.nil?
  end

end