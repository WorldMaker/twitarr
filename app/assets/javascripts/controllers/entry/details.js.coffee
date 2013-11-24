Twitarr.EntryDetailsController = Twitarr.ObjectController.extend Ember.TargetActionSupport,
  replying: false

  actions:
    reply: ->
      @set 'replying', not @get('replying')

    cancel_reply: ->
      @set 'replying', false

    favorite: (id) ->
      return if @get('model.user_liked')
      Twitarr.Post.favorite(id).done (data) =>
        return alert(data.status) unless data.status is 'ok'
        Ember.run =>
          @set 'model.user_liked', true
          @set 'model.liked_sentence', data.sentence

  post_by_friend: (->
    _(@get('friends')).contains @get('from')
  ).property('friends', 'from')

  entry_class: (->
    switch @get('type')
      when 'announcement' then 'announcement-entry'
      when 'post' then 'post-entry'
  ).property('type')

  liked_class: (->
    return 'glyphicon glyphicon-star' if @get('user_liked')
    'glyphicon glyphicon-star-empty'
  ).property('user_liked')

  can_delete: (->
    return false unless @get('logged_in')
    return true if @get('login_admin')
    @get('login_user') is @get('username')
  ).property('logged_in', 'login_user', 'login_admin')

  can_reply: (->
    @get('type') isnt 'announcement'
  ).property('type')

  can_like: (->
    @get('type') isnt 'announcement' and not @get('user_liked')
  ).property('user_liked', 'type')

  reply_template: (->
    'posts/create'
  ).property('type')