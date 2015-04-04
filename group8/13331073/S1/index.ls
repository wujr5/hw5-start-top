window.onload = !->
	add-clicking-to-fetch-the-number-to-button!
	add-clicking-to-calculate-the-sum-to-bubble!
	document.get-element-by-id 'at_plus' .onmouseout = reset-the-calculator


add-clicking-to-fetch-the-number-to-button = !->
	reset-all-the-buttons!
	for i from 0 to 4
		button(i).onclick = ->
			get-random-number(@number)

add-clicking-to-calculate-the-sum-to-bubble = !->
	document.get-element-by-id 'info-bar' .onclick = !->
		if not all-button-done! then return
		random-number = document.get-elements-by-class-name 'number'
		add = 0;
		[add += parse-int random-number[i].innerHTML for i from 0 to 4]
		Info_bar!.innerHTML = add
		Info_bar!.style.background-color = 'gray'


all-button-done = ->
	[return false for i from 0 to 4 when number(i).innerHTML is '...']
	change-bubble-color-while-bubble-can-click!
	true

get-random-number = (this_number) !->
	if button(this_number).classList.contains 'disable' or button(this_number).classList.contains 'waiting' then return
	button(this_number).classList.remove 'enable'
	button(this_number).classList.add 'disable'
	disable-all-other-buttons this_number
	show-number-area this_number
	fetch-number this_number

disable-all-other-buttons = (this_number) !->
	for i from 0 to 4 when i isnt this_number
		button(i).classList.add 'waiting'
		change-buttons-color-to-gray-after-click(i)

show-number-area = (this_number) !->
	number(this_number).style.opacity = '1';

fetch-number = (this_number) !->
	request = new XMLHttpRequest()
	request.onreadystatechange = !->
		if request.ready-state == 4 and request.status == 200
			number(this_number).innerHTML = request.responseText
			enable-all-other-button(this_number)
			if all-button-done! then add-clicking-to-calculate-the-sum-to-bubble!
	request.open "GET", "/" + this_number, true
	request.send!

enable-all-other-button = (this_number) !->
	for i from 0 to 4
		button(i).classList.remove 'waiting'
		if i isnt this_number and button(i).classList.contains 'enable'
			change-buttons-color-to-blue-after-click(i)
		else
			change-buttons-color-to-gray-after-click(i)

reset-the-calculator = !->
	reset-all-the-buttons!
	reset-the-bubble!

reset-all-the-buttons = !->
	for i from 0 to 4
		button(i).classList.add 'enable'
		button(i).classList.remove 'disable'
		change-buttons-color-to-blue-after-click(i)
		number(i).innerHTML = "..."
		number(i).style.opacity = '0'

reset-the-bubble = !->
	Info_bar!.innerHTML = ""

button = (position) ->
	buttons = $(".char")
	buttons[position].number = position
	buttons[position]

number = (position) ->
	numbers = $(".number")
	numbers[position]

letter = (position) ->
	letters = $(".letter")
	letters[position]

Info_bar = ->
	bars = $('#info-bar')[0]

change-bubble-color-while-bubble-can-click = !->
	$('#info-bar')[0].style.background-color = 'rgba(48, 63, 159, 1)'

change-buttons-color-to-gray-after-click = (position) !->
	letter(position).style.background-color = 'gray'

change-buttons-color-to-blue-after-click = (position) !->
	letter(position).style.background-color = 'rgba(48, 63, 159, 1)'
