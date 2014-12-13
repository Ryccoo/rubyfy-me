module ApplicationHelper
  def active_page(name)
    'active' if controller_name == name
  end
end
