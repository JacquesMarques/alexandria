# Load the Rails application.
require_relative "application"

Money.locale_backend = :i18n
Money.rounding_mode = BigDecimal::ROUND_HALF_UP

# Initialize the Rails application.
Rails.application.initialize!
