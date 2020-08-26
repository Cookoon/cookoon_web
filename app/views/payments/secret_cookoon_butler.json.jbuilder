# <%#= @intent_secret_json.html_safe %>
# <%= @stripe_intent_secret_json.html_safe %>
json.extract! @stripe_intent, :client_secret
