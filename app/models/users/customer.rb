class Customer < User
  has_many :orders, :dependent => :restrict_with_error, foreign_key: "user_id"
end
