require 'sequel'
require_relative 'plugins/debug_bar'

# require 'sequel/plugins/after_initialize'

DB = Sequel.sqlite('/Users/avi/code/2025/jan/roda-30day-clone/database/database.sqlite')


Sequel::Model.plugin :debug_bar

class Employer < Sequel::Model
end

puts Employer.first.inspect

# puts Employer.plugins.include?(:after_initialize)


# Sequel::Model.plugin :after_initialize
# Sequel::Model.plugin :debug_bar

# class Employer < Sequel::Model
#   plugin :debug_bar
# end

# Employer.plugin :after_initialize
# Employer.plugin :debug_bar

# puts Employer.first.inspect

# a = Employer.create(name: 'alksgj')

# # puts Employer.plugins.include?(:after_initialization)
# puts Employer.plugins.include?(:debug_bar)

# # puts Sequel::Model.plugins.include?(:debug_bar)
