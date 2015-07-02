defmodule Jtv.Router do
  use Jtv.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Jtv do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", Jtv do
    pipe_through :api

    post "/hit", HitController, :create
  end

  socket "/ws", Jtv do
    channel "stats:*", StatsChannel
  end
end
