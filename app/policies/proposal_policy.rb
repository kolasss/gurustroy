class ProposalPolicy < ApplicationPolicy

  def show?
    true
  end

  def create?
    user.supplier?
  end

  def update?
    user.admin? || (user.supplier? && record.user == user)
  end

  def destroy?
    user.admin?
  end

  # def cancel?
  #   record.live? && update?
  # end
end
