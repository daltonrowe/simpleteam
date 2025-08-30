# Simpleteam

Simple way to collect status updates from small teams.

## Development

```zsh
bin/dev

# lint erb
erb_lint --lint-all -a

# lint js
bin/prettier write
```

## Run Linting

## References

https://greg.molnar.io/blog/tailwindcss-and-rails-8/
https://medium.com/@rob__race/adding-sign-up-to-the-rails-8-authentication-generator-ae24facc624f

## Configuration

- All secrets are stored in rails credentials store via: `bin/rails credentials:edit`
- All secrets need to be mocked in the test env: `config/environments/test.rb`
- All settings are stored in a settings initializer: `config/initializers/settings.rb`

```
# edit credits for a given env
RAIL_ENV=something VISUAL="code --wait" bin/rails credentials:edit
```
