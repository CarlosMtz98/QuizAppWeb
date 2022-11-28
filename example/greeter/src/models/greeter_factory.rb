# The Greeter App
# Date: 07-May-2021
# Author: Ariel Ortiz

require 'json'
require 'models/greeter'

# The +GreeterFactory+ is an implementation of the {Simple
# Factory Pattern}[https://en.wikipedia.org/wiki/Factory_method_pattern].
# It allows you to create instances of the ::Greeter class
# by calling the ::create class method.
class GreeterFactory

  @@greetings = JSON.parse(File.read('./models/greetings.json'))

  # Get all the language names that are available for creating
  # greeter objects.
  #
  # Returns:: An array with the name of the languages.
  def self.available_languages
    @@greetings.keys
  end

  # Creates a new greeter object.
  #
  # Parameter::
  #   language:: The language for the greeter object
  #              that will be created.
  #
  # Returns:: The newly created greeter object.
  #
  # Raises:: +ArgumentError+ if +language+ is unknown.
  def self.create(language)
    raise ArgumentError.new("Unknow language: '#{ language}'") \
      if !@@greetings.key?(language)
    Greeter.new(language, @@greetings[language])
  end

end
