Twitarr.User = Ember.Object.extend
  save: ->
    post_data = { 
      display_name: @get('display_name'), 
      email: @get('email'), 
      room_number: @get('room_number'), 
      "email_public?": @get('email_public?'), 
      real_name: @get('real_name'), 
      home_location: @get('home_location'), 
      "vcard_public?": @get('vcard_public?') 
    }

    if @get('current_password') and @get('new_password') and @get('confirm_password')
      if @get('new_password') != @get('confirm_password')
        alert "New Password and Confirm New Password do not match!"
        return
      post_data["current_password"] = @get('current_password')
      post_data["new_password"] = @get('new_password')

    $.post("#{Twitarr.api_path}/user/profile", post_data).fail (response) -> 
      alert JSON.parse(response.responseText).status;

Twitarr.User.reopenClass
  get: ->
    $.getJSON("#{Twitarr.api_path}/user/whoami").then (data) =>
      @create(data.user)

Twitarr.UserMeta = Ember.Object.extend
  username: null
  display_name: null
  email: null
  room_number: null
  real_name: null
  home_location: null
  number_of_tweets: null
  number_of_mentions: null
  "vcard_public?": null
  starred: null
  # TODO: this is an interesting idea, but don't have time now
#  current_location: null
#  location_timestamp: null

  star: ->
    $.getJSON("#{Twitarr.api_path}/user/profile/#{@get('username')}/star").then (data) =>
      if(data.status == 'ok')
        @set('starred', data.starred)
      else
        alert data.status
  
  vcard_url: (->
    "#{Twitarr.api_path}/user/profile/#{@get('username')}/vcf"
  ).property()

Twitarr.UserProfile = Twitarr.UserMeta.extend
  recent_tweets: []

  objectize: (->
    @set('recent_tweets', Ember.A(Twitarr.StreamPost.create(tweet)) for tweet in @get('recent_tweets'))
  ).on('init')

Twitarr.UserProfile.reopenClass
  get: (username) ->
    $.getJSON("#{Twitarr.api_path}/user/profile/#{username}").then (data) =>
      alert(data.status) unless data.status is 'ok'
      @create data.user 

Twitarr.UserNew = Ember.Object.extend
  username: null
  email: null
  new_password: null
  new_password2: null
  security_question: null
  security_answer: null

Twitarr.UserNew.reopenClass
  save: (new_username, email, new_password, new_password2, security_question, security_answer) -> 
    if new_password != new_password2
      alert "Password and Confirm Password do not match!"
      return

    post_data = { 
      new_username: new_username, 
      email: email, 
      new_password: new_password,
      security_question: security_question, 
      security_answer: security_answer
    }

    return $.post("#{Twitarr.api_path}/user/new", post_data)