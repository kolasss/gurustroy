# == Schema Information
#
# Table name: proposals
#
#  id          :integer          not null, primary key
#  order_id    :integer
#  description :text
#  price       :integer
#  status      :integer          default(0), not null
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_proposals_on_order_id  (order_id)
#  index_proposals_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_0224a90884  (user_id => users.id)
#  fk_rails_315d700991  (order_id => orders.id)
#

require 'test_helper'

class ProposalTest < ActiveSupport::TestCase

  def setup
    @proposal = Proposal.new(
      description: 'Проверка предложения',
      price: 300,
      order: orders(:order_one),
      user: users(:supplier3)
    )
  end

  test "should be valid" do
    assert @proposal.valid?
  end

  test "user should be present" do
    @proposal.user = nil
    assert_not @proposal.valid?
  end

  test "order should be present" do
    @proposal.order = nil
    assert_not @proposal.valid?
  end

  test "should be uniq in scope order-user" do
    @proposal.user = users(:supplier)
    assert_not @proposal.valid?
  end

  test "status should be present" do
    @proposal.status = nil
    assert_not @proposal.valid?
  end

  test "status should be live" do
    assert @proposal.live?
  end

  test "should have photo" do
    proposal = proposals(:winner)
    photo = photos(:two)
    assert_equal proposal.photo, photo
    # file path: test/fixtures/files/uploads/photo/file/298486374/photo.jpg
    assert File.exists?(proposal.photo.file.path)
  end

  test "associated photo should be destroyed" do
    proposal = proposals(:winner)
    photo = photos(:two)
    assert_difference 'Photo.count', -1 do
      proposal.destroy
    end
  end

  test "should accept nested attributes for photo" do
    assert_difference 'Photo.count' do
      @proposal.assign_attributes(
        photo_attributes: {
          file: Rack::Test::UploadedFile.new(
            File.join(ActionController::TestCase.fixture_path, '/files/mister.jpg'),
            'image/jpg'
          )
        }
      )
      @proposal.save
    end
    assert @proposal.reload.photo.present?
  end

  test "should destroy photo through accept nested attributes" do
    proposal = proposals(:winner)
    assert_difference 'Photo.count', -1 do
      proposal.update(
        photo_attributes: {
          id: proposal.photo.id,
          _destroy: true
        }
      )
    end
  end

  test "shoule have scope not_deleted" do
    assert Proposal.not_deleted
  end

  test "shoule have scope by_created" do
    assert Proposal.by_created
  end

  test "method find_deleted_or_initialize should initialize proposal" do
    order = orders(:order_one)
    user = users(:supplier3)
    params = {price: 100}
    new_proposal = Proposal.find_deleted_or_initialize user, order, params
    assert_not new_proposal.persisted?
  end

  test "method find_deleted_or_initialize should find deleted proposal" do
    order = orders(:order_one)
    user = users(:supplier4)
    params = {price: 100}
    deleted_proposal = proposals(:proposal_deleted)
    new_proposal = Proposal.find_deleted_or_initialize user, order, params
    assert new_proposal.persisted?
    deleted_proposal.status = Proposal.statuses[:live]
    assert_equal new_proposal, deleted_proposal
  end
end
