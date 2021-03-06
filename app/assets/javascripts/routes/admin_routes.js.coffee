Twitarr.AdminUsersRoute = Ember.Route.extend
  model: (params) ->
    $.getJSON("#{Twitarr.api_path}/admin/users/#{params.text}")

  setupController: (controller, model) ->
    if model.status isnt 'ok'
      alert model.status
    else
      controller.set('search_text', model.search_text)
      controller.set('model', model.users)

  actions:
    reload: ->
      @refresh()

    save: (user) ->
      $.post("#{Twitarr.api_path}/admin/users/#{user.username}", {
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
      $.post("#{Twitarr.api_path}/admin/users/#{username}/activate").then (data) =>
        if (data.status isnt 'ok')
          alert data.status
        else
          @refresh()

    reset_password: (username) ->
      $.post("#{Twitarr.api_path}/admin/users/#{username}/reset_password").then (data) =>
        if (data.status isnt 'ok')
          alert data.status
        else
          @refresh()

    search: (text) ->
      if !!text
        @transitionTo('admin.users', text)

Twitarr.AdminSearchRoute = Ember.Route.extend
  actions:
    search: (text) ->
      if !!text
        @transitionTo('admin.users', text)

Twitarr.AdminAnnouncementsRoute = Ember.Route.extend
  model: ->
    $.getJSON("#{Twitarr.api_path}/admin/announcements")

  setupController: (controller, model) ->
    controller.set('text', null)
    controller.set('hours', 4)
    if model.status isnt 'ok'
      alert model.status
    else
      controller.set('model', model.list)

  actions:
    new: (text, hours) ->
      $.post("#{Twitarr.api_path}/admin/announcements", { text: text, hours: hours }).then (data) =>
        if (data.status isnt 'ok')
          alert data.status
        else
          @refresh()

Twitarr.AdminUploadScheduleRoute = Ember.Route.extend()
