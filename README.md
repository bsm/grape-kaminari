# Grape::Kaminari [![Gem Version](https://badge.fury.io/rb/grape-kaminari.png)](http://badge.fury.io/rb/grape-kaminari)

[kaminari](https://github.com/amatsuda/kaminari) paginator integration for [grape](https://github.com/intridea/grape) API framework.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'grape-kaminari'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install grape-kaminari
```

## Usage

```ruby
class MyApi < Grape::API
  # Include Grape::Kaminari module in your api
  include Grape::Kaminari

  resource :posts do
    desc 'Return a list of posts.'

    # Annotate action with `paginate`.
    # This will add two optional params: page and per_page
    # You can optionally overwrite the default :per_page setting (10)
    # and the :max_per_page(false/disabled) setting which will use a validator to
    # check that per_page is below the given number.
    paginate :per_page => 20, :max_per_page => 30

    get do
      posts = Post.where(...)

      # Use `paginate` helper to execute kaminari methods
      # with arguments automatically passed from params
      paginate(posts)
    end
  end
end
```

Now you can make a HTTP request to you are endpoint with `page` (and `per_page`) params

```
curl -v http://host.dev/api/posts?page=3
```

and the response will be paginated and also will include pagination headers

```
X-Total: 42
X-Total-Pages: 5
X-Page: 3
X-Per-Page: 10
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
