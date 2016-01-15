class Admin < User
  # has_many :proposals, :dependent => :restrict_with_error
  # has_many :orders, through: :proposals
end
