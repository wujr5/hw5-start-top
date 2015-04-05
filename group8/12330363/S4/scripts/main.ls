class Button
  @buttons = []

  @enable-other-buttons = (this-button) ->
    [btn.enable! for btn in @buttons when btn isnt this-button and btn.state isnt 'done']
  
  @disable-other-buttons = (this-button) ->
    [btn.disable! for btn in @buttons when btn isnt this-button and btn.state isnt 'done']

  @check-all-buttons = ->
    [return false for btn in @buttons when btn.state isnt 'done']
    true
    
  @clear-all = !->
    [btn.clear! for btn in @buttons]

  (@dom, @good-message, @bad-message) ->
    @state = 'enabled'
    @dom.remove-class 'disabled' .add-class 'enabled'
    @name = @dom .text!
    @dom.click !~>
      if @state is 'enabled'
        @@@disable-other-buttons @
        number = @dom.find '.number'
        number .text "..."
        number .css "visibility", "visible"
        @get-and-show-number!

    @@@buttons.push @

  enable: !->
    @dom.remove-class 'disabled' .add-class 'enabled'

  disable: !->
    @dom.remove-class 'enabled' .add-class 'disabled'

  done: !->
    @state = 'done'

  clear: !->
    number = @dom.find '.number'
    number .css "visibility","hidden"
    @state = 'enabled'
    @dom.remove-class 'disabled' .add-class 'enabled'

  get-and-show-number: !-> $.get '/', (number) !~>
    @disable!
    @number = number
    @show-number!
    @done!
    @@@all-buttons-set-callback! if @@@check-all-buttons!
    @@@enable-other-buttons @
    @@@this-button-click-callback!

  show-number: !->
    @dom.find '.number' .text @number

  show-message: (msg) !->
    console.log "#{@name} says: #{msg}"


$ ->
  # initialize all listeners
  set-all-buttons!
  set-large-bubble!
  set-apb! 

  # initialize robot
  # Let robot move
  robot.init!
  click-buttons-serially-in-random-order!

set-all-buttons = !->
  for let btn, i in $ '#control-ring .button'
    # instantiate a Button object for better manipulation
    button = new Button ($ btn)

set-large-bubble = !->
  large-bubble = $ '#info-bar'
  large-bubble.state = 'disabled'
  # large-bubble funcion enable when all buttons checked
  Button.all-buttons-set-callback = !->
    large-bubble.state = 'enabled'
  # click large bubble, obtain the sum
  large-bubble.click !~>
    if large-bubble.state is 'enabled'
      total = 0
      for btn in Button.buttons
        total += (parse-int btn.number)
      large-bubble.find '#sum' .text total
      large-bubble.state = 'disabled'

set-apb = !->
  $ '#button' .on 'mouseleave' (event) !->
    Button.clear-all!
    $ '#sum' .text ''
    $ '#show-order-sequence' .text ''


robot =
  init: !->
    @buttons = $ '#control-ring .button'
    @large-bubble = $ '#info-bar'
    @order-sequence = ['A' to 'E']
    @cur = 0

  shuffle: !->
    @order-sequence.sort -> 0.5 - Math.random!

  next-button: ->
    i = @order-sequence[@cur++].char-code-at! - 'A'.char-code-at!
    @buttons[i]

  click-next: !->
    if @cur isnt @buttons.length
      @next-button!click!
    else
      @large-bubble.click!

  show-order: !->
    sequence-str = @order-sequence.join ','
    @large-bubble.find '#show-order-sequence' .text sequence-str

# Robot's moves
click-buttons-serially-in-random-order = !->
  $ '#button .apb' .click !->
    robot.shuffle!
    robot.show-order!
    Button.this-button-click-callback = !->
      robot.click-next!
    robot.click-next!
