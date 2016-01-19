class ProposalPolicy < ApplicationPolicy

  def show?
    true
  end

  def create?
    user.supplier?
  end

  def update?
    record.live? && (user.admin? || (user.supplier? && record.user == user))
  end

  def destroy?
    user.admin?
  end

  def cancel?
    update?
  end
end
