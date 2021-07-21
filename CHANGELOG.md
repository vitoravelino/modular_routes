## [Unreleased]

**REMOVED**

- `modular_route` helper was removed due to lack of syntax flexibility and a bit of inline verbosity.

**NEW**

- `modular_routes` helper was added to fix the problems encountered on the previous helper. Check the example below:

  ```ruby
    modular_routes do
      resources :books

      get :about, to: "about#index"
    end
  ```

  The idea was to bring simplicity and proximity to what you already write in your routes file.

- `namespace` support`

  ```ruby
    namespace :v1 do
      resources :books
    end
  ```

  It falls back to Rails default behavior.

- `scope` support

  ```ruby
    scope :v1 do
      resources :books
    end

    scope module: :v1 do
      resources :books
    end
  ```

  It falls back to Rails default behavior. In this example it recognizes `/v1/books` and `/books` expecting `BooksController` and `V1::BooksController` respectively.

- Nested resources support

  ```ruby
    modular_routes do
      resources :books do
        resources :comments
      end
    end
  ```

  It recognizes paths like `/books/1/comments/2`.

- Standalone (non-resourceful) routes

  ```ruby
    modular_routes do
      get :about, to: "about#index"
    end
  ```

  It expects `About::IndexController` to exist in `controllers/about/index_controller.rb`. They don't belong to a resourceful scope.

  If `to` doesn't match `controller#action` pattern, it falls back to Rails default behavior.

## [0.1.1] - 2021-07-15

- Initial release
