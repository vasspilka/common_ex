# ExCommons App for Umbrella

ExCommons functionality I occasionally find usefull.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `ex_commons` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:ex_commons, "~> 0.1.0"}]
    end
    ```

  2. Ensure `common` is started before your application:

    ```elixir
    def application do
      [applications: [:ex_commons]]
    end
    ```

