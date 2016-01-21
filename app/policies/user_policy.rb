class UserPolicy < ApplicationPolicy

  def index?
    user.admin?
  end

  def show?
    true
  end

  def create?
    index?
  end

  def update?
    index? || user == record
  end

  def destroy?
    index?
  end

  def orders?
    show? && (record.customer? || record.supplier?)
  end

  def proposals?
    show? && (record.supplier?)
  end

  def change_type?
    index?
  end
end
