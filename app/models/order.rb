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

class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  belongs_to :unit

  has_many :proposals, :dependent => :destroy
  has_one :photo, as: :post, dependent: :destroy
  accepts_nested_attributes_for :photo, allow_destroy: true

  validates :user, presence: true
  validates :category, presence: true
  validates :status, presence: true

  enum status: {
    live: 0,
    finished: 10,
    canceled: 20
  }

  scope :by_created, -> { order(created_at: :desc) }

  def cancel!
    transaction do
      proposals.not_deleted.each do |proposal|
        proposal.order_canceled!
      end
      canceled!
    end
  end

  def finish! accepted_proposal_id
    accepted_proposal_id = accepted_proposal_id.to_i
    if have_live_proposal_with_id?(accepted_proposal_id)
      transaction do
        proposals.live.each do |proposal|
          if proposal.id == accepted_proposal_id
            proposal.accepted!
          else
            proposal.rejected!
          end
        end
        finished!
      end
    else
      errors.set :proposal_id , :invalid
      return false
    end
  end

  def have_live_proposal_with_id? proposal_id
    proposals.live.where(id: proposal_id).present?
  end
end
