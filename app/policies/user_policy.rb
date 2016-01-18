class UserPolicy < ApplicationPolicy

  def index?
    user.admin?
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

  def orders?
    show? && (record.customer? || record.supplier?)
  end

  def proposals?
    show? && (record.supplier?)
  end
end
