module ApplicationHelper
  def active_page(name, action = nil)
    active = controller_name == name
    (active = active && action_name == action) if action

    'active' if active
  end
end
