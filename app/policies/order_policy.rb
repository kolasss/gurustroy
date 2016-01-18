class OrderPolicy < ApplicationPolicy

  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.customer?
  end

  def update?
    user.admin? || (user.customer? && record.user == user)
  end

  def destroy?
    user.admin?
  end

  def cancel?
    record.live? && update?
  end
end
