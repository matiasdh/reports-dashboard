# frozen_string_literal: true

# Pagy initializer for Reports Dashboard
# See https://ddnexus.github.io/pagy/resources/initializer/

# Items per page (reports table)
Pagy.options[:limit] = 10

# For :countish paginator: cache count for 5 min to avoid COUNT(*) on every request
Pagy.options[:ttl] = 300
