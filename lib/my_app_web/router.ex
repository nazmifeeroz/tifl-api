defmodule MyAppWeb.Router do
  use MyAppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: MyAppWeb.Schema,
      interface: :simple


  end
  # scope "/api", MyAppWeb do
  #   pipe_through :api

  #   forward "/graphiql", Absinthe.Plug.GraphiQL,
  #   schema: MyApp.Schema

  #   forward "/", Absinthe.Plug,
  #   schema: MyApp.Schema
  # end
end
