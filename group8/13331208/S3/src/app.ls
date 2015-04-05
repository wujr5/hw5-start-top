class button-manager
  @buttons = []
  @disable-other-buttons = (current)-> [button.disable! for button in @buttons when button isnt current and button.state isnt 'done']
  @enable-other-buttons = (current)-> [button.enable! for button in @buttons when button isnt current and button.state isnt 'done']
  @all-button-is-done = ->
    [return false for button in @buttons when button.state isnt 'done']
    true
  @reset-all-style = !-> [(button.reset!; button.text-invisible!) for button in @buttons]
  (@btn-dom, @name, @fetched-callback)->
    @state = 'enabled'
    @btn-dom.add-class 'enabled'
    @btn-dom.click !~>
      if @state is 'enabled'
        robot.next-button-click!
        @@@disable-other-buttons @
        @text-visible!
        @wait!
        @get-random-number!
    @@@buttons.push @
  get-random-number: !-> $.get '/api/random', (number, result)!~>
    if robot.apb-state is 'disabled'
      @done!
      @@@all-fetched-enable-bubble! if @@@all-button-is-done!
      @@@enable-other-buttons @
      @show-number number
      @fetched-callback number

  wait: !->
    @state = 'waiting'
    @btn-dom.remove-class 'enabled' .add-class 'waiting'

  text-visible: !-> @btn-dom.remove-class 'invisible'; @btn-dom.add-class 'visible'

  text-invisible: !-> @btn-dom.remove-class 'visible'; @btn-dom.add-class 'invisible'

  done: !->
    @state = 'done'
    @btn-dom.remove-class 'waiting' .add-class 'done'

  show-number: (number)!-> @btn-dom.find '.unread' .text number

  disable: !-> @state = 'disabled' ; @btn-dom.remove-class 'enabled' .add-class 'disabled'

  enable: !-> @state = 'enabled' ; @btn-dom.remove-class 'disabled' .add-class 'enabled'

  reset: !->
    @state = 'enabled' ; @btn-dom.remove-class 'disabled waiting done' .add-class 'enabled'
    @btn-dom.find '.unread' .text ''

caculator =
  sum: 0
  add: (number)-> @sum += parse-int number
  reset: !-> @sum = 0

reset = !->
  caculator.reset!
  button-manager.reset-all-style!
  bubble = $ '#info-bar' 
  bubble.remove-class 'enabled' .add-class 'disabled'
  bubble.find '.amount' .text ''
  robot.apb-state = 'enabled'
  robot.index = 0

robot =
  initial: !->
    @buttons = $ '#control-ring .button'
    @bubble = $ '#info-bar'
    @apb-state = 'enabled'
    @index = 0

  next-button-click: !-> if @index is @buttons.length
    then @bubble.click!
    else @buttons[@index++].click!

$ ->
  robot.initial!
  set-click-event-to-all-button!
  set-click-event-to-apb!
  get-sum-and-show-in-bubble!
  reset-when-leaved!

set-click-event-to-all-button = !->
  i = 0
  for btn-dom in $ '#control-ring .button'
    button = new button-manager ($ btn-dom), i++, (number)->
      caculator.add number;
      if button-manager.all-button-is-done
        robot.bubble.click!

set-click-event-to-apb = !->
  $ '#button .apb' .on 'click' (event)!->
    if robot.apb-state is 'enabled'
      robot.apb-state = 'disabled'
      robot.next-button-click!

get-sum-and-show-in-bubble = !->
  bubble = $ '#info-bar' 
  button-manager.all-fetched-enable-bubble = !->
    bubble.remove-class 'disabled' .add-class 'enabled'
    bubble.click
  bubble.click !-> if bubble.has-class 'enabled'
    if button-manager.all-button-is-done
      bubble.find '.amount' .text caculator.sum
      bubble.remove-class 'enabled' .add-class 'disabled'

reset-when-leaved = !->
  $ '#bottom-positioner' .mouseleave !-> reset!
