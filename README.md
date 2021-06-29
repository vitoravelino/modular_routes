# Modular Routes

A simple way of having dedicated controllers for each of your route actions.

If you've ever used [Hanami routes](https://guides.hanamirb.org/v1.3/routing/restful-resources/) or already use dedicated controllers for each route action, this gem might be useful.

## Motivation

How do you organize your controllers and routes of your Rails application?

The most common approach is to have all the actions (RESTful and customs) in the same controller.

```ruby
# routes.rb

resources :todos do
  post :complete, on: :member
end

# todo_controller.rb

class TodoController
  def index
  end

  #...

  def complete
  end
end
```

[DHH](http://jeromedalbert.com/how-dhh-organizes-his-rails-controllers/) prefers to keep the RESTful actions (index, new, edit, show, create, update, destroy) inside the same controller and the custom ones in dedicated controllers.

```ruby
# routes.rb

resources :todos, only: :index do
  post :complete, on: :member, controller: 'todos/complete'
end

# todo_controller.rb

class TodoController
  def index
  end

  # ...
end

# todo/complete_controller.rb

class Todo::CompleteController
  def complete
  end
end
```

What I personally prefer is one controller per route action just like it was done for the `complete` action but for all the RESTful actions. Let's see two ways of doing that

```ruby
# routes.rb

resources :todos, module: :todos, only: [] do
  collection do
    get :index, to: 'index#call'
  end

  member do
    put :complete, to: 'complete#call'
  end
end
```

or

```ruby
# routes.rb

scope module: :todos, path: '/todos' do
  get '/',            to: 'index#call',    as: 'todos'
  put ':id/complete', to: 'complete#call', as: 'complete_todo'
end
```

The controllers would be organized as

```ruby
# todos/index_controller.rb

class Todos::IndexController
  def call
  end
end

# todos/complete_controller.rb

class Todos::CompleteController
  def call
  end
end
```

To be clear, there's no better/worse nor right/wrong, it's up to you to decide how you prefer to organize the controllers and routes of your application.

But from now on let's assume that you've decided to organize your application by having a dedicated controller for each route action.

You are now facing the scenario of designing a full RESTful resource named `books` with some custom actions like the table below

| HTTP Verb | Path                | Controller#Action   | Named Route Helper       |
| --------- | ------------------- | ------------------- | ------------------------ |
| GET       | /books              | books/index#call    | books_path               |
| GET       | /books/new          | books/new#call      | new_book_path            |
| POST      | /books              | books/create#call   | books_path               |
| GET       | /books/:id          | books/show#call     | books_path(:id)          |
| GET       | /books/:id/edit     | books/edit#call     | edit_books_path(:id)     |
| PATCH/PUT | /books/:id          | books/update#call   | books_path(:id)          |
| DELETE    | /books/:id          | books/destroy#call  | books_path(:id)          |
| POST      | /books/request      | books/request#call  | requests_books_path(:id) |
| POST      | /books/:id/favorite | books/favorite#call | favorite_book_path(:id)  |

How could we do that with the same approach we've used in the last example?

```ruby
scope module: :books, path: '/books' do
  get    '/',        to: 'index#call', as: 'books'
  post   '/',        to: 'create#call'

  get    'new',      to: 'new#call',  as: 'new_book'
  get    ':id/edit', to: 'edit#call', as: 'edit_book'
  get    ':id',      to: 'show#call', as: 'book'
  patch  ':id',      to: 'update#call'
  put    ':id',      to: 'update#call'
  delete ':id',      to: 'destroy#call'

  post 'request',      to: 'request#call',  as: 'requests_books'
  post ':id/favorite', to: 'favorite#call', as: 'favorite_book'
end
```

or

```ruby
resources :books, module: :books, only: [] do
  collection do
    get  :index,   to: 'index#call'
    post :create,  to: 'create#call'
    post :request, to: 'request#call'
  end

  new do
    get :new, to: 'new#call'
  end

  member do
    get    :edit,     to: 'edit#call'
    get    :show,     to: 'show#call'
    patch  :update,   to: 'update#call'
    put    :update,   to: 'update#call'
    delete :destroy,  to: 'destroy#call'
    post   :favorite, to: 'favorite#call'
  end
end
```

So, is that a problem with that? Well, it depends. If you already organize your routes in [separated files](https://guides.rubyonrails.org/routing.html#breaking-up-very-large-route-file-into-multiple-small-ones), you're probably fine. Otherwise your `config/routes.rb` might get really messy as your application grows.

But what if we had a simpler way of doing all of that? Let's take a look at how modular routes gem can help us achieve that.

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

`modular_route` uses `resource` and `resources` route helpers from Rails behind the scenes. So you can pretty much use whatever you already use for them except for a few [limitations](#limitations) that will be explained later.

For the same scenario mentioned on the [motivation](#motivation) section, using modular route we have

```ruby
# routes.rb
modular_route resources: :books, all: true do
  collection do
    post :request
  end

  member do
    post :favorite
  end
end
```

or to be shorter

```ruby
# routes.rb

modular_route resources: :books, all: true do
  post :request, on: :collection
  post :favorite, on: :member
end
```

The only mandatory option to use `modular_route` helper is to pass `:resources` or `:resource` as key with the following resource name.

To generate all RESTful routes, you must pass `all: true`. Otherwise nothing will happen unless you pass a block with custom routes.

### Restricting routes

You can restrict the routes for the RESTful with `:only` and `:except` similar to what you can do in Rails by default.

```ruby
modular_route resources: :books, only: [:index, :show]
```

```ruby
modular_route resources: :books, except: [:destroy]
```

### Renaming paths

As in Rails you can simply use `:path` attribute.

```ruby
modular_route resources: :books, all: true, path: 'livros'
```

is going to produce

| HTTP Verb | Path             | Controller#Action  | Named Route Helper  |
| --------- | ---------------- | ------------------ | ------------------- |
| GET       | /livros          | books/index#call   | books_path          |
| GET       | /livros/new      | books/new#call     | new_book_path       |
| POST      | /livros          | books/create#call  | books_path          |
| GET       | /livros/:id      | books/show#call    | book_path(:id)      |
| GET       | /livros/:id/edit | books/edit#call    | edit_book_path(:id) |
| PATCH/PUT | /livros/:id      | books/update#call  | book_path(:id)      |
| DELETE    | /livros/:id      | books/destroy#call | book_path(:id)      |

### API mode

If your Rails app is with API only mode, then `:edit` and `:new` actions won't be applied.

### Limitations

Some of the restrictions are:

- `path` and `to` options won't have any effect on member/collection routes
- `concerns` won't work for resources
- no support for nesting

#### Nesting

Even without nesting support you can emulate what the expected behaviour would be with the mix of `namespace` and `path` as detailed below

```ruby
namespace :books, path: 'books/:book_id' do
  modular_route resources: :reviews, all: true
end
```

The output routes for that would be

| HTTP Verb | Path                             | Controller#Action          | Named Route Helper           |
| --------- | -------------------------------- | -------------------------- | ---------------------------- |
| GET       | /books/:book_id/reviews          | books/reviews/index#call   | books_reviews_path           |
| GET       | /books/:book_id/reviews/new      | books/reviews/new#call     | new_books_reviews_path       |
| POST      | /books/:book_id/reviews          | books/reviews/create#call  | books_reviews_path           |
| GET       | /books/:book_id/reviews/:id      | books/reviews/show#call    | books_reviews_path(:id)      |
| GET       | /books/:book_id/reviews/:id/edit | books/reviews/edit#call    | edit_books_reviews_path(:id) |
| PATCH/PUT | /books/:book_id/reviews/:id      | books/reviews/update#call  | books_reviews_path(:id)      |
| DELETE    | /books/:book_id/reviews/:id      | books/reviews/destroy#call | books_reviews_path(:id)      |

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/vitoravelino/modular_routes. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/vitoravelino/modular_routes/blob/master/CODE_OF_CONDUCT.md).

## Code of Conduct

Everyone interacting in the ModularRoutes project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/modular_routes/blob/master/CODE_OF_CONDUCT.md).
