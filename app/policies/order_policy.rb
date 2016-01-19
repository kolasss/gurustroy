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
    record.live? && (user.admin? || (user.customer? && record.user == user))
  end

  def destroy?
    user.admin?
  end

  def cancel?
    update?
  end

  def finish?
    cancel?
  end
end
