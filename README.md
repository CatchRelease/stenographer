# Stenographer
Stenographer is a simplistic way to manage your changes and show them to the users. When using an input like Github that
has a unique id shared across branches, it will also manage grouping changes by environment.

## Usage
To create a new item:
```ruby
Stenography::Change.create(message: 'My Change', change_type: 'new/improved/fixed', visible: true, environments: 'production', tracker_ids: '#12345', source: '{}')
```
It's advised to store the source so you can parse it again later if needed.

To View:
```
Open a browser to http://host:port/stenographer or whatever you've set your mount point to.
```

## Automatic Changelogs
1. First, setup your input type in your config/stenographer.rb. As of right now, Stenographer only supports ``Stenographer::Inputs::GithubInput`` which users github webhooks.
1. Then, setup your GitHub webhook setup to use "just the push event" to point at `https://#{YOUR_DOMAIN}/#{STENOGRAPHER_MOUNT_POINT}/changes`
1. Finally, add `[changelog My change message]` to your commits.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'stenographer'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install stenographer
```

Add the configuration and migrations:
```bash
$ rails g stenographer:install
```

## Configuration
All configuration is available in the config/initializers/stenographer.rb

## Developing
#### Running the App
Set up the database

```ruby
$ rake app:db:setup
```

Start the Rails server
```ruby
$ rails s
```

View the site
[http://locahost:3000/stenographer](http://locahost:3000/stenographer)

#### Testing
Set up the database

```ruby
$ RAILS_ENV=test rake app:db:setup
```

Run the tests
```ruby
$ rake spec
```

## Contributing
1. Fork the repo and create your branch.
2. If you've added code that should be tested, add tests.
4. Ensure the test suite passes using `$ rake spec`.
5. Make sure your code lints using `$ rubocop`.
6. Issue that pull request!

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
