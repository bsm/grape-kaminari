# Grape::Kaminari

[![Test](https://github.com/bsm/grape-kaminari/actions/workflows/test.yml/badge.svg)](https://github.com/bsm/grape-kaminari/actions/workflows/test.yml)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

[kaminari](https://github.com/kaminari/kaminari) paginator integration for [grape](https://github.com/intridea/grape) API framework.

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

    # This will add three optional params: page, per_page, and offset
    #
    # You can optionally overwrite the default :per_page setting (10)
    # and the :max_per_page(false/disabled) setting which will use a validator to
    # check that per_page is below the given number.
    #
    # You can disable the offset parameter from appearing in the API
    # documentation by setting it to false.
    #
    params do
      use :pagination, per_page: 20, max_per_page: 30, offset: 5
    end
    get do
      posts = Post.where(...)

      # Use `paginate` helper to execute kaminari methods
      # with arguments automatically passed from params
      paginate(posts)
    end

    get do
      things = ['a', 'standard', 'array', 'of', 'things', '...']

      # Use `Kaminari.paginate_array` method to convert the array
      # into an object that can be passed to `paginate` helper.
      paginate(Kaminari.paginate_array(things))
    end
  end
end
```

Now you can make a HTTP request to your endpoint with the following parameters

- `page`: your current page (default: 1)
- `per_page`: how many to record in a page (default: 10)
- `offset`: the offset to start from (default: 0)

```
curl -v http://host.dev/api/posts?page=3&offset=10
```

and the response will be paginated and also will include pagination headers

```
X-Total: 42
X-Total-Pages: 5
X-Page: 3
X-Per-Page: 10
X-Next-Page: 4
X-Prev-Page: 2
X-Offset: 10
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bsm/grape-kaminari.
