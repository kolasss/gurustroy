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

class Proposal < ActiveRecord::Base
  belongs_to :order
  belongs_to :user

  has_one :photo, as: :post, dependent: :destroy
  accepts_nested_attributes_for :photo, allow_destroy: true

  validates :order, presence: true,
                    uniqueness: {scope: :user_id}
  validates :user, presence: true

  enum status: {
    live: 0,
    accepted: 10,
    rejected: 20,
    deleted: 30,
    order_canceled: 40
  }

  scope :not_deleted, -> { where.not(status: statuses[:deleted]) }
  scope :by_created, -> { order(created_at: :desc) }

  # initialize new proposal
  def Proposal.find_deleted_or_initialize user, order, proposal_params
    proposal = Proposal.where(
      user_id: user,
      order_id: order,
      status: statuses[:deleted]
    ).first
    if proposal.present?
      proposal.assign_attributes proposal_params
      proposal.status = statuses[:live]
    else
      proposal = Proposal.new(proposal_params)
      proposal.order = order
      proposal.user = user
    end
    return proposal
  end
end
