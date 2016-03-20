# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  phone               :string           not null
#  name                :string
#  company             :string
#  type                :string
#  sms_code            :string
#  sms_code_expires_at :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_users_on_phone     (phone) UNIQUE
#  index_users_on_sms_code  (sms_code)
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(
      phone: '79234567890',
      name: 'Проверка пользователя',
      company: 'ООО Компания'
    )
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "phone should be present" do
    @user.phone = nil
    assert_not @user.valid?
  end

  test "phone should be uniq" do
    @user.phone = users(:customer).phone
    assert_not @user.valid?
  end

  test "phone should have correct format" do
    @user.phone = '123'
    assert_not @user.valid?
    @user.phone = 'lalala'
    assert_not @user.valid?
    @user.phone = '1234567890123'
    assert_not @user.valid?
  end

  test "phone should consist only digits" do
    @user.phone = 'asd7923\/.,+45asd6789dfs0-=()*-='
    @user.valid?
    assert_equal '79234567890', @user.phone
  end

  test "shoule have scope by_created" do
    assert User.by_created
  end

  #### User type tests

  test "default type should be Customer" do
    assert_equal nil, @user.type
    @user.valid?
    assert_equal 'Customer', @user.type
  end

  test "should have USER_TYPES" do
    assert User::USER_TYPES
  end

  test "should have PUBLIC_USER_TYPES" do
    assert User::PUBLIC_USER_TYPES
  end

  test "type should be in USER_TYPES list" do
    @user.type = 'coolcat'
    assert_not @user.valid?
  end

  test "should have method customer?" do
    @user.type = 'Customer'
    assert @user.customer?
    @user.type = 'Supplier'
    assert_not @user.customer?
  end

  test "should have method supplier?" do
    @user.type = 'Supplier'
    assert @user.supplier?
    @user.type = 'Customer'
    assert_not @user.supplier?
  end

  test "should have method admin?" do
    @user.type = 'Admin'
    assert @user.admin?
    @user.type = 'Customer'
    assert_not @user.admin?
  end

  test "should have method customer!" do
    assert @user = @user.customer!
    assert_equal 'Customer', @user.class.name
  end

  test "should have method supplier!" do
    assert @user = @user.supplier!
    assert_equal 'Supplier', @user.class.name
  end

  test "should have method admin!" do
    assert @user = @user.admin!
    assert_equal 'Admin', @user.class.name
  end

  test "method change_type should correctly change type" do
    @user.save
    assert_raise NotImplementedError do
      @user.change_type 'Supplier'
    end
    # reload user for change class to Customer
    @user = User.find @user.id
    assert_equal 'Customer', @user.class.name
    # change class of instance with method
    @user = @user.change_type 'Supplier'
    assert_equal 'Supplier', @user.class.name
  end

  test "method change_type should add error on wrong type argument" do
    @user = @user.change_type 'coolcat'
    assert @user.errors.messages.include? :type
  end

  test "should have policy_class" do
    assert_equal UserPolicy, User.policy_class
  end
end
