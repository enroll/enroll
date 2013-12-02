module GroupingHelper
  def group_list_by_date(list, date_field)
    list.group_by { |e| e.send(date_field).to_s(:db) }
  end
end