class Supplier < User
  has_many :proposals, :dependent => :restrict_with_error, foreign_key: "user_id"
  has_many :orders, through: :proposals
end
