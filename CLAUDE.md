# Simpleteam

Simpleteam is a set of simple straightforwards tools for developer teams.

## Brand

- The Simpleteam brand emphasis simplicity, and eschewing over decoration and advanced styling
  seen in modern web properties.
- The color palette is darkish, using shades of `yin` Tailwind color.
- The access color is `red` Tailwind color.

## Code Style

- Use Rails conventions and scaffoldling.
- Use native HTML capabilities as much as possible.
- Stlying is done via Tailwind CSS classes.
- Javascript uses the Stimulus framework, any new Javascript should be generalized and reusable.
- Form elements should be integrated using methods from `config/initializers/simple_team_form_builder.rb`

## Generation

- Creating new HTML View Components components can be performed with `bin/rails g component MyComponentName`
- Creating new JS controller (if absolutely necessary) can be performed with `bin/rails g stimulus MyControllerName`

## Continuous Integration

- The CI workflow (`.github/workflows/ci.yml`) posts a `✅ CI passed` comment on the
  pull request once every check succeeds. That comment is delivered as a webhook event.
- When watching a pull request, always rely on this success comment to confirm CI is
  green. Do not poll or schedule self check-ins to detect CI success — wait for the
  webhook.

## References

- Rails 8 guides and explanations available at https://guides.rubyonrails.org/
- Rails documentation available at https://apidock.com/rails/browse
- View Component documentation available at https://viewcomponent.org/
- Documentation for Stimulus can be found at https://stimulus.hotwired.dev/reference/controllers
