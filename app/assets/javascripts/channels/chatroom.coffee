App.chatroom = App.cable.subscriptions.create "ChatroomChannel",

  connected: ->
   
  disconnected: ->
   
  received: (data) ->
  	$('#messages').append data['message']
  	$('#message_content').val ''
  	scrollToBottom()
  	return
    
  
  scrollToBottom = ->
      if $('#messages').length > 0
        last_message = $('#messages')[0]
        last_message.scrollTop = last_message.scrollHeight - (last_message.clientHeight)
  
  $(document).ready ->
    scrollToBottom()
    return    
   
  jQuery(document).on 'turbolinks:load', ->
    scrollToBottom()
    return   