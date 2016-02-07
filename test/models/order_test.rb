# == Schema Information
#
# Table name: orders
#
#  id          :integer          not null, primary key
#  description :text
#  quantity    :float
#  unit_id     :integer
#  price       :integer
#  status      :integer          default(0), not null
#  category_id :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_orders_on_category_id  (category_id)
#  index_orders_on_unit_id      (unit_id)
#  index_orders_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_3dd05aae5e  (category_id => categories.id)
#  fk_rails_b6a4a01c33  (unit_id => units.id)
#  fk_rails_f868b47f6a  (user_id => users.id)
#

require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  # include ActionDispatch::TestProcess

  def setup
    @order = Order.new(
      description: 'Проверка заказа',
      quantity: 1.7,
      price: 300,
      category: categories(:kirpichi),
      user: users(:customer)
    )
  end

  test "should be valid" do
    assert @order.valid?
  end

  test "user should be present" do
    @order.user = nil
    assert_not @order.valid?
  end

  test "category should be present" do
    @order.category = nil
    assert_not @order.valid?
  end

  test "status should be present" do
    @order.status = nil
    assert_not @order.valid?
  end

  test "status should be live" do
    assert @order.live?
  end

  test "should have proposals" do
    order = orders(:order_one)
    proposal = proposals(:proposal_one)
    assert order.proposals.include? proposal
  end

  test "associated proposals should be destroyed" do
    @order.save
    @order.proposals.create(
      description: 'проверка',
      price: 1212,
      user: users(:supplier)
    )
    assert_difference 'Proposal.count', -1 do
      @order.destroy
    end
  end

  test "should have photo" do
    order = orders(:order_one)
    photo = photos(:one)
    assert_equal order.photo, photo
    # file path: test/fixtures/files/uploads/photo/file/980190962/photo.jpg
    assert File.exists?(order.photo.file.path)
  end

  test "associated photo should be destroyed" do
    order = orders(:order_one)
    photo = photos(:one)
    assert_difference 'Photo.count', -1 do
      order.destroy
    end
  end

  test "should accept nested attributes for photo" do
    assert_difference 'Photo.count' do
      @order.assign_attributes(
        photo_attributes: {
          file: Rack::Test::UploadedFile.new(
            File.join(ActionController::TestCase.fixture_path, '/files/mister.jpg'),
            'image/jpg'
          )
        }
      )
      @order.save
    end
    assert @order.reload.photo.present?
  end

  test "should destroy photo through accept nested attributes" do
    order = orders(:order_one)
    assert_difference 'Photo.count', -1 do
      order.update(
        photo_attributes: {
          id: order.photo.id,
          _destroy: true
        }
      )
    end
  end

  test "shoule have scope by_created" do
    assert Order.by_created
  end

  test "method cancel! should cancel associated proposals and order" do
    order = orders(:order_one)
    live_proposal = proposals(:proposal_one)
    deleted_proposal = proposals(:proposal_deleted)
    order.cancel!
    assert order.reload.canceled?
    assert live_proposal.reload.order_canceled?
    assert deleted_proposal.reload.deleted?
  end

  test "method finish! should correctly finish order" do
    order = orders(:order_one)
    live_proposal = proposals(:proposal_one)
    live_proposal2 = proposals(:proposal_two)
    deleted_proposal = proposals(:proposal_deleted)
    assert order.finish! live_proposal.id
    assert order.reload.finished?
    assert live_proposal.reload.accepted?
    assert live_proposal2.reload.rejected?
    assert deleted_proposal.reload.deleted?
  end

  test "method finish! should return false and add error to order if argument invalid" do
    order = orders(:order_one)
    live_proposal = proposals(:proposal_one)
    live_proposal2 = proposals(:proposal_two)
    deleted_proposal = proposals(:proposal_deleted)
    assert_not order.finish! '1'
    assert order.reload.live?
    assert live_proposal.reload.live?
    assert live_proposal2.reload.live?
    assert deleted_proposal.reload.deleted?
    assert order.errors.any?
  end
end
