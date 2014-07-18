RSpec.configure do |config|
  # Use color in STDOUT
  config.color = true
  # Use color not only in STDOUT but also in pagers and files
  config.tty = true
  # Use the specified formatter
  config.formatter = :documentation
  # continue testing through failures
  config.fail_fast = false
  # prevent deprecation warnings when using #stub
  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end