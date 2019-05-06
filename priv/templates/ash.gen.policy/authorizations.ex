
  alias <%= inspect schema.module %>

  # :create_<%= schema.singular %>
  # Anyone can create a <%= schema.singular %>
  def authorize(:create_<%= schema.singular %>, _user, _resource), do: true

  # :update_<%= schema.singular %>
  # Only a user can update their <%= schema.singular %>
  def authorize(:update_<%= schema.singular %>, %User{id: id}, <%= schema.singular %>),
    do: id == <%= schema.singular %>.user_id

  # Catch all denial
  def authorize(_action, _user, _resource), do: true
