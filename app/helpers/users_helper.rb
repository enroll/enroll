module UsersHelper
  def mailto_users(users)
    joined_emails = users.map(&:email).join(',')
    "mailto:#{joined_emails}"
  end
end