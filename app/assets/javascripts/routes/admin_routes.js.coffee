Twitarr.AdminUsersRoute = Ember.Route.extend
  model: ->
    $.getJSON("admin/users")

  setupController: (controller, model) ->
    if model.status isnt 'ok'
      alert model.status
    else
      controller.set('model', model.list)

  actions:
    reload: ->
      @refresh()

    save: (user) ->
      $.post('admin/update_user', {
        username: user.username
        is_admin: user.is_admin
        status: user.status
        email: user.email
        display_name: user.display_name
      }).then (data) =>
        if data.status is 'invalid'
          alert error for error in data.errors
        else if (data.status isnt 'ok')
          alert data.status
        else
          @refresh()

    activate: (username) ->
      $.post('admin/activate', { username: username }).then (data) =>
        if (data.status isnt 'ok')
          alert data.status
        else
          @refresh()

    reset_password: (username) ->
      $.post('admin/reset_password', { username: username }).then (data) =>
        if (data.status isnt 'ok')
          alert data.status
        else
          @refresh()
