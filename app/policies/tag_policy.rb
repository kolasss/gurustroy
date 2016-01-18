class TagPolicy < UnitPolicy

  def index?
    create?
  end
end
