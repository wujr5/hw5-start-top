class Button
  @FAILURE-RATE = 0.3
  @buttons = []

  @disable-all-other-buttons = (this-button)-> [button.disable! for button in @buttons when button isnt this-button and button.state isnt 'done']

  @enable-all-other-buttons = (this-button)-> [button.enable! for button in @buttons when button isnt this-button and button.state isnt 'done']

  @all-button-is-done = ->
    [return false for button in @buttons when button.state isnt 'done']
    true
  @reset-all = !-> [button.reset! for button in @buttons]

  @all-number-fetched-callback = !-> 
    bubble = $('#info-bar')
    bubble.remove-class 'disabled' .add-class 'enabled'
    set-timeout !->
     bubble.trigger 'click'
    , 1000ms

  (@dom, @number-fetched-callback)->
    @state = 'enabled'
    @dom.add-class 'enabled'
    @name = @dom.find '.title' .text!
    @dom.click !~>
      @show-unread-ring!
      @wait!
      @fetch-number-and-show!
    @@@buttons.push @

  fetch-number-and-show: !-> $.get '/api/random', (number)!~>
    @done!
    @@@all-number-fetched-callback! if @@@all-button-is-done!
    @@@enable-all-other-buttons @
    @show-number number
    @number-fetched-callback number

  show-unread-ring: !-> @dom .find '.unread' .css 'display', 'block'

  show-number: (number)!-> @dom.find '.unread' .text number

  show-message: !-> console.log "Button #{@name} say: #{@good-message}"

  disable: !-> @state = 'disabled' ; @dom.remove-class 'enabled' .add-class 'disabled'

  enable: !-> @state = 'enabled' ; @dom.remove-class 'disabled' .add-class 'enabled'

  wait: !-> @state = 'waiting' ; @dom.remove-class 'enabled' .add-class 'waiting'

  done: !-> @state = 'done' ; @dom.remove-class 'waiting' .add-class 'done'

  reset: !-> 
    @state = 'enabled'
    @dom.remove-class 'disabled waiting done' .add-class 'enabled'
    @dom.find '.unread' .text '' .css 'display', 'none'
    $ '.page.amount' .text ''

cumulator =
  sum: 0
  add: (number)-> @sum += parse-int number
  reset: !-> @sum = 0

robot =
  buttons: -> $ '#control-ring .button'
  action: !-> @buttons! .trigger 'click'

$ !->
  add-clicking-to-fetch-numbers-to-all-buttons!
  add-clicking-to-calculate-result-to-the-bubble!
  add-resetting-when-leave-apb!
  add-clicking-to-action-the-robot!

  s2-action-the-robot!

add-clicking-to-fetch-numbers-to-all-buttons = !-> 
  for dom in $ '#control-ring .button'
    button = new Button ($ dom), (number)!->
      cumulator.add number

add-clicking-to-calculate-result-to-the-bubble = !->
  bubble = $ '#info-bar' 
  bubble.add-class 'disabled'
  bubble.click !-> if bubble.has-class 'enabled'
    bubble.find '.amount' .text cumulator.sum
    bubble.remove-class 'enabled' .add-class 'disabled'

add-resetting-when-leave-apb = !->
  is-enter-other = false
  $ '#info-bar, #control-ring' .on 'mouseenter' !-> is-enter-other := true
  $ '#info-bar, #control-ring' .on 'mouseleave' (event)!-> 
    is-enter-other := false
    set-timeout !-> 
      reset! if not is-enter-other
    , 0

add-clicking-to-action-the-robot = !->
  $ '.icon' .click !-> robot.action!

reset = !->
  cumulator.reset!
  Button.reset-all!
  bubble = $ '#info-bar'
  bubble.remove-class 'enabled' .add-class 'disabled'
  bubble.find '.amount span' .text ''

s2-action-the-robot = !-> console.log "robot clicking action!"

