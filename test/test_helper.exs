ExUnit.start()

if not File.exists?("./test/tmp") do
  File.mkdir!("./test/tmp")
end
