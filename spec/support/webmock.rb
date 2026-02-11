require "webmock/rspec"

# Block all real HTTP requests in tests
WebMock.disable_net_connect!(allow_localhost: true)
