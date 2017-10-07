require 'test_helper'

class ChefTest < ActiveSupport::TestCase
	def setup
		@chef = Chef.new(chefname: "josembi", email: "josembi@example.com")
	end

	test "should be valid" do 
		assert @chef.valid?
	end

	test "name should be present" do 
		@chef.chefname = " "
		assert_not @chef.valid?
	end

	test "name should be less than 30 characters" do 
		@chef.chefname = "a" * 31
		assert_not @chef.valid?
	end

	test "email should be present" do 
		@chef.email = " "
		assert_not @chef.valid?
	end

	test "email should not be too long" do 
		@chef.email = "a" * 245 + "@example.com"
		assert_not @chef.valid?
	end

	test "email address should be valid format" do
		valid_emails = %w[user@example.com JOSEMBI@gmail.com J.first@yahoo.it peter+paul@perlygate.co.uk]
		valid_emails.each do |valids|
			@chef.email = valids 
			assert @chef.valid?, "#{valids.inspect} should be valid"
		end
	end

	test "should reject invalid email addresses"  do 
		invalid_emails = %w[josembi@example josembi@example,com @example.com josembi.name@gmail. joe@foo+bar.com]
		invalid_emails.each do |invalids|
			@chef.email =invalids
			assert_not @chef.valid? "#{invalids.inspect} should be valid"
		end
	end

	test "email should be unique and case insensitive" do 
		duplicate_chef = @chef.dup 
		duplicate_chef.email = @chef.email.dup 
		@chef.save
		assert_not duplicate_chef.valid?
	end

	test "email should be case insensitive" do 

	end
end









