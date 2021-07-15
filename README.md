[gem]: https://rubygems.org/gems/modular_routes
[ci]: https://github.com/vitoravelino/modular_routes/actions/workflows/ci.yml
[coverage]: https://github.com/vitoravelino/modular_routes/actions/workflows/coverage.yml
[codeclimate]: https://codeclimate.com/github/vitoravelino/modular_routes

# Modular Routes

_A simple way of having dedicated controllers for each of your route actions._

[![gem version](https://img.shields.io/gem/v/modular_routes)][gem]
[![CI](https://github.com/vitoravelino/modular_routes/actions/workflows/ci.yml/badge.svg)][ci]
[![Coverage](https://github.com/vitoravelino/modular_routes/actions/workflows/coverage.yml/badge.svg)][coverage]
[![Maintainability](https://img.shields.io/codeclimate/maintainability/vitoravelino/modular_routes)][codeclimate]

If you've ever used [Hanami routes](https://guides.hanamirb.org/v1.3/routing/restful-resources/) or already use dedicated controllers for each route action, this gem might be useful.

Disclaimer: There's no better/worse nor right/wrong approach, it's up to you to decide how you prefer to organize the controllers and routes of your application.

## Motivation

Let's imagine that you have to design a full RESTful resource named `articles` with some custom routes like the table below

| HTTP Verb | Path                  |
| --------- | --------------------- |
| GET       | /articles             |
| GET       | /articles/new         |
| POST      | /articles             |
| GET       | /articles/:id         |
| GET       | /articles/:id/edit    |
| PATCH/PUT | /articles/:id         |
| DELETE    | /articles/:id         |
| GET       | /articles/stats       |
| POST      | /articles/:id/archive |

How would you organize the controllers and routes of this application?

The most common approach is to have all the actions (RESTful and customs) in the same controller.

```ruby
# routes.rb

resources :articles do
  get  :stats,   on: :collection
  post :archive, on: :member
end

# articles_controller.rb

class ArticlesController
  def index
    # ...
  end

  def create
    # ...
  end

  # other actions...

  def stats
    # ...
  end

  def archive
    # ...
  end
end
```

The reason I don't like this approach is that you can end up with a lot of code that are not related to each other in the same file. You can still have it all organized but I believe that it could be better.

[DHH](http://jeromedalbert.com/how-dhh-organizes-his-rails-controllers/) prefers to keep the RESTful actions (index, new, edit, show, create, update, destroy) inside the same controller and the custom ones in dedicated controllers.

One way of representing that would be

```ruby
# routes.rb

resources :articles do
  get  :stats,   on: :collection, controller: 'articles/stats'
  post :archive, on: :member,     controller: 'articles/archive'
end

# articles_controller.rb

class ArticlesController
  def index
    # ...
  end

  def create
    # ...
  end

  # other actions...
end

# articles/archive_controller.rb

class Articles::ArchiveController
  def archive
  end
end

# articles/stats_controller.rb

class Articles::StatsController
  def stats
  end
end
```

This approach is better than the previous one because it restricts the main controller file to contain only the RESTful actions. Additional routes would require you to create a dedicated controller to handle that individually.

Another approach (and what I personally prefer) is to have one controller per route. What it was done for `archive` and `stats` routes would also be applied to all the RESTful routes.

The files would be organized inside `articles/` folder that would act as a namespace

```
app/
└── controllers/
    └── articles/
        ├── archive_controller.rb
        ├── create_controller.rb
        ├── destroy_controller.rb
        ├── edit_controller.rb
        ├── index_controller.rb
        ├── new_controller.rb
        ├── show_controller.rb
        ├── stats_controller.rb
        └── update_controller.rb
```

And the controllers would have one single action named `call` like

```ruby
# articles/index_controller.rb

class Articles::IndexController
  def call
  end
end

# articles/archive_controller.rb

class Articles::ArchiveController
  def call
  end
end
```

Here are two ways of representing what was explained above:

```ruby
scope module: :articles, path: '/articles' do
  get    '/',        to: 'index#call', as: 'articles'
  post   '/',        to: 'create#call'

  get    'new',      to: 'new#call',  as: 'new_article'
  get    ':id/edit', to: 'edit#call', as: 'edit_article'
  get    ':id',      to: 'show#call', as: 'article'
  patch  ':id',      to: 'update#call'
  put    ':id',      to: 'update#call'
  delete ':id',      to: 'destroy#call'

  post 'stats',       to: 'stats#call',   as: 'stats_articles'
  post ':id/archive', to: 'archive#call', as: 'archive_article'
end
```

or

```ruby
resources :articles, module: :articles, only: [] do
  collection do
    get  :index,  to: 'index#call'
    post :create, to: 'create#call'
    post :stats,  to: 'stats#call'
  end

  new do
    get :new, to: 'new#call'
  end

  member do
    get    :edit,    to: 'edit#call'
    get    :show,    to: 'show#call'
    patch  :update,  to: 'update#call'
    put    :update,  to: 'update#call'
    delete :destroy, to: 'destroy#call'
    post   :archive, to: 'archive#call'
  end
end
```

This is the best approach in my opinion because your controller will contain only code related to that specific route action. It will also be easier to test and maintain the code.

If you've decided to go with the last approach, unless you organizes your routes in [separated files](https://guides.rubyonrails.org/routing.html#breaking-up-very-large-route-file-into-multiple-small-ones), your `config/routes.rb` might get really messy as your application grows due to verbosity.

So, what if we had a simpler way of doing all of that? Let's take a look at how modular routes can help us.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "modular_routes"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install modular_routes

## Usage

`modular_route` uses `resource` and `resources` route helpers behind the scenes. So you can pretty much use almost everything you already use with them except for a few [limitations](#limitations) that will be explained later.

For the same example used in the [motivation](#motivation) section, using modular routes we now have

```ruby
# routes.rb

modular_route resources: :articles, all: true do
  collection do
    post :stats
  end

  member do
    post :archive
  end
end
```

or to be shorter

```ruby
# routes.rb

modular_route resources: :articles, all: true do
  post :stats,   on: :collection
  post :archive, on: :member
end
```

The only mandatory option to use `modular_route` helper is to pass `:resources` or `:resource` as key with the following resource name.

To generate all RESTful routes, you must pass `all: true`. Otherwise nothing will happen unless you pass a block with additional routes.

The output routes for the code above would be

| HTTP Verb | Path                  | Controller#Action     | Named Route Helper        |
| --------- | --------------------- | --------------------- | ------------------------- |
| GET       | /articles             | articles/index#call   | articles_path             |
| GET       | /articles/new         | articles/new#call     | new_article_path          |
| POST      | /articles             | articles/create#call  | articles_path             |
| GET       | /articles/:id         | articles/show#call    | articles_path(:id)        |
| GET       | /articles/:id/edit    | articles/edit#call    | edit_articles_path(:id)   |
| PATCH/PUT | /articles/:id         | articles/update#call  | articles_path(:id)        |
| DELETE    | /articles/:id         | articles/destroy#call | articles_path(:id)        |
| POST      | /articles/stats       | articles/stats#call   | stats_articles_path(:id)  |
| POST      | /articles/:id/archive | articles/archive#call | archive_article_path(:id) |

### Restricting routes

You can restrict the routes for the RESTful with `:only` and `:except` similar to what you can do in Rails by default.

```ruby
modular_route resources: :articles, only: [:index, :show]
```

```ruby
modular_route resources: :articles, except: [:destroy]
```

### Renaming paths

As in Rails you can simply use `:path` attribute.

```ruby
modular_route resources: :articles, all: true, path: 'posts'
```

is going to produce

| HTTP Verb | Path            | Controller#Action     | Named Route Helper     |
| --------- | --------------- | --------------------- | ---------------------- |
| GET       | /posts          | articles/index#call   | articles_path          |
| GET       | /posts/new      | articles/new#call     | new_article_path       |
| POST      | /posts          | articles/create#call  | articles_path          |
| GET       | /posts/:id      | articles/show#call    | article_path(:id)      |
| GET       | /posts/:id/edit | articles/edit#call    | edit_article_path(:id) |
| PATCH/PUT | /posts/:id      | articles/update#call  | article_path(:id)      |
| DELETE    | /posts/:id      | articles/destroy#call | article_path(:id)      |

### API mode

If your Rails app is with API only mode, then `:edit` and `:new` actions won't be applied.

### Limitations

Some of the restrictions are:

- `concerns` won't work
- `constraints` only as option and not block
- no support for nesting

#### Nesting

Even without nesting support you can emulate what the expected behaviour would be mixing `namespace` and `path` as detailed below

```ruby
namespace :books, path: 'books/:book_id' do
  modular_route resources: :reviews, all: true
end
```

The output routes for that would be

| HTTP Verb | Path                             | Controller#Action          | Named Route Helper              |
| --------- | -------------------------------- | -------------------------- | ------------------------------- |
| GET       | /books/:book_id/reviews          | books/reviews/index#call   | books_reviews_path              |
| GET       | /books/:book_id/reviews/new      | books/reviews/new#call     | new_articles_reviews_path       |
| POST      | /books/:book_id/reviews          | books/reviews/create#call  | books_reviews_path              |
| GET       | /books/:book_id/reviews/:id      | books/reviews/show#call    | books_reviews_path(:id)         |
| GET       | /books/:book_id/reviews/:id/edit | books/reviews/edit#call    | edit_articles_reviews_path(:id) |
| PATCH/PUT | /books/:book_id/reviews/:id      | books/reviews/update#call  | books_reviews_path(:id)         |
| DELETE    | /books/:book_id/reviews/:id      | books/reviews/destroy#call | books_reviews_path(:id)         |

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/vitoravelino/modular_routes. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/vitoravelino/modular_routes/blob/master/CODE_OF_CONDUCT.md).

## Code of Conduct

Everyone interacting in the ModularRoutes project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/vitoravelino/modular_routes/blob/master/CODE_OF_CONDUCT.md).

## Licensing

Modular Routes is licensed under the Apache License, Version 2.0. See [LICENSE](https://github.com/vitoravelino/modular_routes/blob/master/LICENSE) for the full license text.
