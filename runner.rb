require_relative 'lib/email_predictor.rb'

[
  ["Peter Wong", "alphasights.com"],
  ["Craig Silverstein", "google.com"],
  ["Steve Wozniak", "apple.com"],
  ["Barack Obama", "whitehouse.gov"]
].each do |args|
  email_predictor = EmailPredictor.new(*args)
  puts "Prediction for #{args} is: #{email_predictor.predict}"
end