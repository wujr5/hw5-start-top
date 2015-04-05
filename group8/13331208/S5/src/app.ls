class aHandler
  @disable-other-buttons = (current)-> [button.disable! for button in robot.handlers when button isnt current and button.state isnt 'done']
  @enable-other-buttons = (current)-> [button.enable! for button in robot.handlers when button isnt current and button.state isnt 'done']
  @all-button-is-done = ->
    [return false for button in robot.handlers when button.state isnt 'done']
    true
  @reset-all-style = !-> [(button.reset!; button.text-invisible!) for button in robot.handlers]
  @fetched-callback = (error, number)!->
    if error
      console.log "Handle error from #{@name}, message is: #{error.message}"
      $ '#region' .text "Handle error from #{@name}, message is: #{error.message}"
      number = error.data
    robot.next-button-click!
  (@btn-dom)->
    @fail-message = '这不是个天大的秘密'
    @success-message = '这是个天大的秘密'
    @state = 'enabled'
    @btn-dom.add-class 'enabled'
    @name = @btn-dom.find '.title' .text!
    @btn-dom.click !~> if @state is 'enabled'
      @@@disable-other-buttons @
      @text-visible!
      @wait!
      @get-random-number!
    robot.handlers.push @
  get-random-number: !-> $.get '/api/random', (number, result)!~>
    if @state is 'waiting'
      @done!
      robot.all-fetched-enable-bubble! if @@@all-button-is-done!
      @@@enable-other-buttons @
      @error-handler number

  error-handler: (number)!-> 
    if is-success = Math.random! > robot.failure-rate
      @show-message @success-message
      @show-number number
      caculator.add number
      @@@fetched-callback error = null, number
    else
      @text-invisible!
      @@@fetched-callback message: @fail-message, data: number

  show-message: !-> console.log "Button #{@name} say: #{@success-message}";$ '#region' .text "Button #{@name} say: #{@success-message}"
  
  wait: !->
    @state = 'waiting'
    @btn-dom.remove-class 'enabled' .add-class 'waiting'

  text-visible: !-> @btn-dom.remove-class 'invisible' .add-class 'visible'

  text-invisible: !-> @btn-dom.remove-class 'visible' .add-class 'invisible'

  done: !->
    @state = 'done'
    @btn-dom.remove-class 'waiting' .add-class 'done'

  show-number: (number)!~> @btn-dom.find '.unread' .text number

  disable: !-> @state = 'disabled' ; @btn-dom.remove-class 'enabled' .add-class 'disabled'

  enable: !-> @state = 'enabled' ; @btn-dom.remove-class 'disabled' .add-class 'enabled'

  reset: !->
    @state = 'enabled' ; @btn-dom.remove-class 'disabled waiting done' .add-class 'enabled'
    @btn-dom.find '.unread' .text ''

class bHandler
  @disable-other-buttons = (current)-> [button.disable! for button in robot.handlers when button isnt current and button.state isnt 'done']
  @enable-other-buttons = (current)-> [button.enable! for button in robot.handlers when button isnt current and button.state isnt 'done']
  @all-button-is-done = ->
    [return false for button in robot.handlers when button.state isnt 'done']
    true
  @reset-all-style = !-> [(button.reset!; button.text-invisible!) for button in robot.handlers]
  @fetched-callback = (error, number)!->
    if error
      console.log "Handle error from #{@name}, message is: #{error.message}";$ '#region' .text "Handle error from #{@name}, message is: #{error.message}"
      number = error.data
    robot.next-button-click!
  (@btn-dom)->
    @success-message = '我知道'
    @fail-message = '我不知道'
    @state = 'enabled'
    @btn-dom.add-class 'enabled'
    @name = @btn-dom.find '.title' .text!
    @btn-dom.click !~> if @state is 'enabled'
      @@@disable-other-buttons @
      @text-visible!
      @wait!
      @get-random-number!
    robot.handlers.push @
  get-random-number: !-> $.get '/api/random', (number, result)!~>
    if @state is 'waiting'
      @done!
      robot.all-fetched-enable-bubble! if @@@all-button-is-done!
      @@@enable-other-buttons @
      @error-handler number

  error-handler: (number)!-> 
    if Math.random! > robot.failure-rate
      @show-message @success-message
      @show-number number
      caculator.add number
      @@@fetched-callback error = null, number
    else
      @text-invisible!
      @@@fetched-callback message: @fail-message, data: number 

  show-message: !-> console.log "Button #{@name} say: #{@success-message}";$ '#region' .text "Button #{@name} say: #{@success-message}"
  
  wait: !->
    @state = 'waiting'
    @btn-dom.remove-class 'enabled' .add-class 'waiting'

  text-visible: !-> @btn-dom.remove-class 'invisible' .add-class 'visible'

  text-invisible: !-> @btn-dom.remove-class 'visible' .add-class 'invisible'

  done: !->
    @state = 'done'
    @btn-dom.remove-class 'waiting' .add-class 'done'

  show-number: (number)!~> @btn-dom.find '.unread' .text number

  disable: !-> @state = 'disabled' ; @btn-dom.remove-class 'enabled' .add-class 'disabled'

  enable: !-> @state = 'enabled' ; @btn-dom.remove-class 'disabled' .add-class 'enabled'

  reset: !->
    @state = 'enabled' ; @btn-dom.remove-class 'disabled waiting done' .add-class 'enabled'
    @btn-dom.find '.unread' .text ''

class cHandler
  @disable-other-buttons = (current)-> [button.disable! for button in robot.handlers when button isnt current and button.state isnt 'done']
  @enable-other-buttons = (current)-> [button.enable! for button in robot.handlers when button isnt current and button.state isnt 'done']
  @all-button-is-done = ->
    [return false for button in robot.handlers when button.state isnt 'done']
    true
  @reset-all-style = !-> [(button.reset!; button.text-invisible!) for button in robot.handlers]
  @fetched-callback = (error, number)!->
    if error
      console.log "Handle error from #{@name}, message is: #{error.message}";$ '#region' .text "Handle error from #{@name}, message is: #{error.message}"
      number = error.data
    robot.next-button-click!
  (@btn-dom)->
    @success-message = '你知道'
    @fail-message = '你不知道'
    @state = 'enabled'
    @btn-dom.add-class 'enabled'
    @name = @btn-dom.find '.title' .text!
    @btn-dom.click !~> if @state is 'enabled'
      @@@disable-other-buttons @
      @text-visible!
      @wait!
      @get-random-number!
    robot.handlers.push @
  get-random-number: !-> $.get '/api/random', (number, result)!~>
    if @state is 'waiting'
      @done!
      robot.all-fetched-enable-bubble! if @@@all-button-is-done!
      @@@enable-other-buttons @
      @error-handler number

  error-handler: (number)!-> 
    if Math.random! > robot.failure-rate
      @show-message @success-message
      @show-number number
      caculator.add number
      @@@fetched-callback error = null, number
    else
      @text-invisible!
      @@@fetched-callback message: @fail-message, data: number 

  show-message: !-> console.log "Button #{@name} say: #{@success-message}";$ '#region' .text "Button #{@name} say: #{@success-message}"
  
  wait: !->
    @state = 'waiting'
    @btn-dom.remove-class 'enabled' .add-class 'waiting'

  text-visible: !-> @btn-dom.remove-class 'invisible' .add-class 'visible'

  text-invisible: !-> @btn-dom.remove-class 'visible' .add-class 'invisible'

  done: !->
    @state = 'done'
    @btn-dom.remove-class 'waiting' .add-class 'done'

  show-number: (number)!~> @btn-dom.find '.unread' .text number

  disable: !-> @state = 'disabled' ; @btn-dom.remove-class 'enabled' .add-class 'disabled'

  enable: !-> @state = 'enabled' ; @btn-dom.remove-class 'disabled' .add-class 'enabled'

  reset: !->
    @state = 'enabled' ; @btn-dom.remove-class 'disabled waiting done' .add-class 'enabled'
    @btn-dom.find '.unread' .text ''

class dHandler
  @disable-other-buttons = (current)-> [button.disable! for button in robot.handlers when button isnt current and button.state isnt 'done']
  @enable-other-buttons = (current)-> [button.enable! for button in robot.handlers when button isnt current and button.state isnt 'done']
  @all-button-is-done = ->
    [return false for button in robot.handlers when button.state isnt 'done']
    true
  @reset-all-style = !-> [(button.reset!; button.text-invisible!) for button in robot.handlers]
  @fetched-callback = (error, number)!->
    if error
      console.log "Handle error from #{@name}, message is: #{error.message}";$ '#region' .text "Handle error from #{@name}, message is: #{error.message}"
      number = error.data
    robot.next-button-click!
  (@btn-dom)->
    @success-message = '他知道'
    @fail-message = '他不知道'
    @state = 'enabled'
    @btn-dom.add-class 'enabled'
    @name = @btn-dom.find '.title' .text!
    @btn-dom.click !~> if @state is 'enabled'
      @text-visible!
      @@@disable-other-buttons @
      @wait!
      @get-random-number!
    robot.handlers.push @
  get-random-number: !-> $.get '/api/random', (number, result)!~>
    if @state is 'waiting'
      @done!
      robot.all-fetched-enable-bubble! if @@@all-button-is-done!
      @@@enable-other-buttons @
      @error-handler number

  error-handler: (number)!-> 
    if Math.random! > robot.failure-rate
      @show-message @success-message
      @show-number number
      caculator.add number
      @@@fetched-callback error = null, number
    else
      @text-invisible!
      @@@fetched-callback message: @fail-message, data: number 

  show-message: !-> console.log "Button #{@name} say: #{@success-message}";"Button #{@name} say: #{@success-message}"
  
  wait: !->
    @state = 'waiting'
    @btn-dom.remove-class 'enabled' .add-class 'waiting'

  text-visible: !-> @btn-dom.remove-class 'invisible' .add-class 'visible'

  text-invisible: !-> @btn-dom.remove-class 'visible' .add-class 'invisible'

  done: !->
    @state = 'done'
    @btn-dom.remove-class 'waiting' .add-class 'done'

  show-number: (number)!~> @btn-dom.find '.unread' .text number

  disable: !-> @state = 'disabled' ; @btn-dom.remove-class 'enabled' .add-class 'disabled'

  enable: !-> @state = 'enabled' ; @btn-dom.remove-class 'disabled' .add-class 'enabled'

  reset: !->
    @state = 'enabled' ; @btn-dom.remove-class 'disabled waiting done' .add-class 'enabled'
    @btn-dom.find '.unread' .text ''

class eHandler
  @disable-other-buttons = (current)-> [button.disable! for button in robot.handlers when button isnt current and button.state isnt 'done']
  @enable-other-buttons = (current)-> [button.enable! for button in robot.handlers when button isnt current and button.state isnt 'done']
  @all-button-is-done = ->
    [return false for button in robot.handlers when button.state isnt 'done']
    true
  @reset-all-style = !-> [(button.reset!; button.text-invisible!) for button in robot.handlers]
  @fetched-callback = (error, number)!->
    if error
      console.log "Handle error from #{@name}, message is: #{error.message}";"Handle error from #{@name}, message is: #{error.message}"
      number = error.data
    robot.next-button-click!
  (@btn-dom)->
    @success-message = '才怪'
    @fail-message = '才怪才怪'
    @state = 'enabled'
    @btn-dom.add-class 'enabled'
    @name = @btn-dom.find '.title' .text!
    @btn-dom.click !~> if @state is 'enabled'
      @@@disable-other-buttons @
      @text-visible!
      @wait!
      @get-random-number!
    robot.handlers.push @
  get-random-number: !-> $.get '/api/random', (number, result)!~>
    if @state is 'waiting'
      @done!
      robot.all-fetched-enable-bubble! if @@@all-button-is-done!
      @@@enable-other-buttons @
      @error-handler number

  error-handler: (number)!-> 
    if Math.random! > robot.failure-rate
      @show-message @success-message
      @show-number number
      caculator.add number
      @@@fetched-callback error = null, number
    else
      @text-invisible!
      @@@fetched-callback message: @fail-message, data: number 

  show-message: !-> console.log "Button #{@name} say: #{@success-message}";"Button #{@name} say: #{@success-message}"
  
  wait: !->
    @state = 'waiting'
    @btn-dom.remove-class 'enabled' .add-class 'waiting'

  text-visible: !-> @btn-dom.remove-class 'invisible' .add-class 'visible'

  text-invisible: !-> @btn-dom.remove-class 'visible' .add-class 'invisible'

  done: !->
    @state = 'done'
    @btn-dom.remove-class 'waiting' .add-class 'done'

  show-number: (number)!~> @btn-dom.find '.unread' .text number

  disable: !-> @state = 'disabled' ; @btn-dom.remove-class 'enabled' .add-class 'disabled'

  enable: !-> @state = 'enabled' ; @btn-dom.remove-class 'disabled' .add-class 'enabled'

  reset: !->
    @state = 'enabled' ; @btn-dom.remove-class 'disabled waiting done' .add-class 'enabled'
    @btn-dom.find '.unread' .text ''

bubbleHandler =
  initial: !->
    @dom = $ '#info-bar'
    @message = '楼主异步调用战斗力感人，目测不超过'
    @dom .click !~> if @dom.has-class 'enabled'
      @dom.find '.amount' .text caculator.sum
      @dom.remove-class 'enabled' .add-class 'disabled'
      @show-message caculator.sum
  show-message: (current-sum)!-> console.log "Bubble say: #{@message} #{current-sum}";$ '#region' .text "Bubble say: #{@message} #{current-sum}"
  reset: !-> @dom.find '.sequence span' .text ''; @dom.find '.amount' .text ''; @dom.remove-class 'enabled' .add-class 'disabled'

caculator =
  sum: 0
  add: (number)-> @sum += parse-int number
  reset: !-> @sum = 0

reset-all = !->
  caculator.reset!
  aHandler.reset-all-style!
  bHandler.reset-all-style!
  cHandler.reset-all-style!
  dHandler.reset-all-style!
  eHandler.reset-all-style!
  bubbleHandler.reset!
  robot.apb-state = 'enabled'
  robot.index = 0
  $ '#region' .text ''

robot =
  initial: !->
    $ '#region' .text ''
    @failure-rate = 0.35
    @buttons = $ '#control-ring .button'
    @handlers = []
    @bubble = $ '#info-bar'
    @apb-state = 'enabled'
    @order = ['A' to 'E']
    @index = 0

  next-button-click: !-> if @index is @buttons.length
    then @bubble.click!
    else @buttons[@order[@index++].charCodeAt(0)-65].click!

  shuffle: !-> @order.sort -> 0.5 - Math.random!

  show-order: !-> @bubble.find '.sequence span' .text @order.join ', '

  all-fetched-enable-bubble: !-> @bubble.remove-class 'disabled' .add-class 'enabled'

$ ->
  robot.initial!
  bubbleHandler.initial!
  robot.handlers.push(new aHandler ($ robot.buttons[0]))
  robot.handlers.push(new bHandler ($ robot.buttons[1]))
  robot.handlers.push(new cHandler ($ robot.buttons[2]))
  robot.handlers.push(new dHandler ($ robot.buttons[3]))
  robot.handlers.push(new eHandler ($ robot.buttons[4]))
  set-click-event-to-apb!
  reset-when-leaved!

set-click-event-to-apb = !->
  $ '#button .apb' .on 'click' (event)!->
    if robot.apb-state is 'enabled'
      reset-all!
      robot.shuffle!
      robot.show-order!
      robot.next-button-click!
      robot.apb-state = 'disabled'

reset-when-leaved = !->
  $ '#bottom-positioner' .mouseleave !-> reset-all!
