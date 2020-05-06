require "httparty"
require "plek"

require_relative "../retry_while_false"

namespace :govuk do
  desc "Wait until router is serving routes that are non server errors"
  task :wait_for_router do
    outcome = RetryWhileFalse.call(reload_seconds: 60, interval_seconds: 1) do
      live = HTTParty.head(Plek.find("www")).code
      draft = HTTParty.head(Plek.find("draft-origin")).code
      live < 500 && draft < 500
    end

    abort "Router has no routes after 60 seconds" unless outcome
  end
end
