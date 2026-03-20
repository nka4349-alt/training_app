Rails.autoloaders.each do |autoloader|
  autoloader.inflector.inflect(
    "e1rm" => "E1RM"
  )
end
