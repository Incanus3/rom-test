module CommonViews
  def by_id(id)
    where(id: id) #.one!
  end
end
