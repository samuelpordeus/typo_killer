use Mix.Config

if Mix.env() == :test do
  config :mix_test_watch, clear: true
end
