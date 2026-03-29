# Rails Conventions

These conventions apply to all Rails projects under ~/code/.

## Services

**Verb-first naming.** Services describe what they do: `CreatesUrlEpisode`, `ChecksRateLimit`, `GeneratesAudio`. Not `EpisodeService`, `AudioTranscriber`, `Enricher`.

**`.call` class method entry point.** Every service follows this pattern:

```ruby
class ChecksRateLimit
  include StructuredLogging

  def self.call(user:)
    new(user: user).call
  end

  def initialize(user:)
    @user = user
  end

  def call
    # business logic
  end

  private

  attr_reader :user
end
```

**Return Result objects, not raw values.** Services return `Result.success(data)` or `Result.failure(error_message)`. Callers check `result.success?`. Reserve exceptions for truly unexpected failures.

```ruby
# In the service
Result.success(episode)
Result.failure("Rate limit exceeded")

# In the caller
result = ChecksRateLimit.call(user: current_user)
if result.success?
  # proceed
else
  redirect_to root_path, alert: result.error
end
```

## Result Object

Every project should have `app/models/result.rb`:

```ruby
class Result
  attr_reader :data, :error, :error_type, :message

  def initialize(success:, data:, error:, error_type: nil, message: nil)
    @success = success
    @data = data
    @error = error
    @error_type = error_type
    @message = message
    freeze
  end

  def self.success(data = nil, message: nil, **kwargs)
    actual_data = data.nil? && kwargs.any? ? kwargs : data
    new(success: true, data: actual_data, error: nil, message: message)
  end

  def self.failure(error, message: nil, error_type: nil)
    new(success: false, data: nil, error: error, error_type: error_type, message: message || error)
  end

  def success?
    @success
  end

  def failure?
    !@success
  end
end
```

## Structured Logging

Use the `StructuredLogging` concern — not inline `Rails.logger` calls with hand-built JSON.

```ruby
# Good
include StructuredLogging
log_info "rate_limit_checked", user_id: user.id, remaining: 5

# Bad
Rails.logger.info(JSON.generate({ event: "rate_limit_checked", user_id: user.id }))
```

The concern lives in `app/services/concerns/structured_logging.rb`:

```ruby
module StructuredLogging
  extend ActiveSupport::Concern

  private

  def log_info(event, **attrs)
    Rails.logger.info build_log_message(event, attrs)
  end

  def log_warn(event, **attrs)
    Rails.logger.warn build_log_message(event, attrs)
  end

  def log_error(event, **attrs)
    Rails.logger.error build_log_message(event, attrs)
  end

  def default_log_context
    { action_id: Current.action_id }.compact
  end

  def build_log_message(event, attrs)
    context = default_log_context.merge(attrs)
    parts = [ "event=#{event}" ]
    context.each { |k, v| parts << "#{k}=#{v}" if v.present? }
    parts.join(" ")
  end
end
```

## Configuration

**Centralize constants in `AppConfig`.** Group with nested modules. Freeze values.

```ruby
class AppConfig
  module Api
    DEFAULT_PER_PAGE = 20
    MAX_PER_PAGE = 100
  end

  module Content
    MIN_LENGTH = 100
    MAX_FETCH_BYTES = 10 * 1024 * 1024
  end
end
```

Don't scatter constants across controllers and models. `ItemsController::PAGE_SIZE` should be `AppConfig::Api::DEFAULT_PER_PAGE`.

**ENV access:** Always `ENV.fetch("KEY", default)` — never bare `ENV["KEY"]` (which silently returns nil).

## Jobs

**Retry transient errors with backoff.** Define transient error lists, use `retry_on` with `:polynomially_longer`.

```ruby
class GeneratesAudioJob < ApplicationJob
  queue_as :default
  limits_concurrency to: 1, key: ->(item_id:, **) { Item.find(item_id).id }

  retry_on *TRANSIENT_ERRORS, wait: :polynomially_longer, attempts: 3 do |job, error|
    job.handle_retries_exhausted(error)
  end

  def perform(item_id:, action_id: nil)
    # work
  end

  def handle_retries_exhausted(error)
    # mark record as failed with error message
  end
end
```

Don't rely solely on a global `rescue_from` in `ApplicationJob`.

## Current Attributes

Use `ActiveSupport::CurrentAttributes` for request-scoped context. At minimum, track `action_id` for distributed tracing.

```ruby
class Current < ActiveSupport::CurrentAttributes
  attribute :session, :action_id
  delegate :user, to: :session, allow_nil: true
end
```

Set `action_id` in `ApplicationController`, pass to jobs, include in structured log output.

## Prefixed IDs

Use the `prefixed_ids` gem for public-facing IDs. Database keeps integer PKs internally.

```ruby
class Item < ApplicationRecord
  has_prefix_id :item
end

# item.prefix_id => "item_a1b2c3"
```

Never expose raw integer IDs in URLs or API responses.

## Testing

- **Framework:** Minitest, not RSpec.
- **Mocking:** Mocktail for object mocking, Webmock for HTTP stubs. Reset Mocktail in teardown.
- **Fixtures:** Use YAML fixtures. Load with `fixtures :all`.
- **Assertions:** Prefer specific assertions (`assert_equal`, `assert_includes`, `assert_response :success`) over generic `assert`.
- **Jobs:** Use `assert_enqueued_with(job: JobClass)` and `perform_enqueued_jobs` for synchronous execution in tests.

## Code Style

- `# frozen_string_literal: true` at the top of every `.rb` file.
- Rubocop with `rubocop-rails-omakase`. Minimal overrides.
- `bin/rails test && bin/rubocop` must both pass before opening a PR.

## Verification

Before claiming work is done:

```bash
bin/rails test && bin/rubocop
```

Both must pass. Tests passing with lint failures means CI will fail.
