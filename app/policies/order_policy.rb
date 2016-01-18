class OrderPolicy < ApplicationPolicy

  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.admin?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end
end
