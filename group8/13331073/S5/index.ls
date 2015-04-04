window.onload = !->
	add-clicking-to-fetch-the-number-to-button!
	add-clicking-to-calculate-the-sum-to-bubble!
	robot-click!
	document.get-element-by-id 'at_plus' .onmouseout = reset-the-calculator


add-clicking-to-fetch-the-number-to-button = !->
	reset-all-the-buttons!
	for i from 0 to 4
		button(i).onclick = !->
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
	fetch-number this_number, button(this_number).callback

disable-all-other-buttons = (this_number) !->
	for i from 0 to 4 when i isnt this_number
		button(i).classList.add 'waiting'
		change-buttons-color-to-gray-after-click(i)

show-number-area = (this_number) !->
	number(this_number).style.opacity = '1';

fetch-number = (this_number, callback) !->
	xmlhttp = new XMLHttpRequest()
	xmlhttp.onreadystatechange = !->
		if xmlhttp.ready-state == 4 and xmlhttp.status == 200
			callback(xmlhttp.responseText)
	xmlhttp.open "GET", "/" + this_number, true
	xmlhttp.send!

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
		button(i).classList.remove 'waiting'
		change-buttons-color-to-blue-after-click(i)
		number(i).innerHTML = "..."
		number(i).style.opacity = '0'

reset-the-bubble = !->
	$("p")[0].innerHTML = ""
	$('#message')[0].innerHTML = ""
	Info_bar!.innerHTML = ""

robot-click = !->
	at-plus!.onclick = !->
		order = [0 to 4]
		order.sort ->
			if Math.random! > 0.5 then -1 else 1
		show-order order
		click-next-button 0, order, 0

click-next-button = (sum, order, position) !->
	if position is 5
		bubbleHandler sum
		return
	button-number = order[position]
	if button(button-number).classList.contains 'disable'
		addition-in-number = number(button-number).innerHTML
		click-next-button sum + parse-int addition-in-number, order, position+1
	Info_bar!.innerHTML = sum
	handle-result = (error-infomation, sum, order, position) !->
		if error-infomation isnt null
			console.log error-infomation
			click-next-button sum, order,position
		else
			click-next-button sum, order,position
	switch button-number
	case 0 then aHandler sum, order, position, handle-result
	case 1 then bHandler sum, order, position, handle-result
	case 2 then cHandler sum, order, position, handle-result
	case 3 then dHandler sum, order, position, handle-result
	case 4 then eHandler sum, order, position, handle-result

bubbleHandler = (sum) !->
	$('#message')[0].innerHTML = '楼主异步调用战斗力感人，目测不超过: ' + sum
	Info_bar!.innerHTML = sum

is-failed = ->
	Math.random! < 0.5

aHandler = (sum, order, position, handle-result) !->
	if button(0).classList.contains 'disable' or button(0).classList.contains 'waiting' then return
	button(0).classList.remove 'enable'
	button(0).classList.add 'disable'
	disable-all-other-buttons 0
	show-number-area 0
	is-fail = is-failed!
	if not is-fail then $('#message')[0].innerHTML = "这是个天大的秘密" else $('#message')[0].innerHTML = "这不是个天大的秘密"
	fetch-number(0, (text) !->
		enable-all-other-button 0
		if not is-fail
			number(0).innerHTML = text
			sum += parse-int text
			handle-result null, sum, order, position+1
		else
			handle-result 'A failed!', sum, order, position+1
	);

bHandler = (sum, order, position, handle-result) !->
	if button(1).classList.contains 'disable' or button(1).classList.contains 'waiting' then return
	button(1).classList.remove 'enable'
	button(1).classList.add 'disable'
	disable-all-other-buttons 1
	show-number-area 1
	is-fail = is-failed!
	if not is-fail then $('#message')[0].innerHTML = "我不知道" else $('#message')[0].innerHTML = "我知道"
	fetch-number(1, (text) !->
		enable-all-other-button 1
		if not is-fail
			number(1).innerHTML = text
			sum += parse-int text
			handle-result null, sum, order, position+1
		else
			handle-result 'B failed!', sum, order, position+1
	);

cHandler = (sum, order, position, handle-result) !->
	if button(2).classList.contains 'disable' or button(2).classList.contains 'waiting' then return
	button(2).classList.remove 'enable'
	button(2).classList.add 'disable'
	disable-all-other-buttons 2
	show-number-area 2
	is-fail = is-failed!
	if not is-fail then $('#message')[0].innerHTML = "你不知道" else $('#message')[0].innerHTML = "你知道"
	fetch-number(2, (text) !->
		enable-all-other-button 2
		if not is-fail
			number(2).innerHTML = text
			sum += parse-int text
			handle-result null, sum, order, position+1
		else
			handle-result 'C failed!', sum, order, position+1
	);

dHandler = (sum, order, position, handle-result) !->
	if button(3).classList.contains 'disable' or button(3).classList.contains 'waiting' then return
	button(3).classList.remove 'enable'
	button(3).classList.add 'disable'
	disable-all-other-buttons 3
	show-number-area 3
	is-fail = is-failed!
	if not is-fail then $('#message')[0].innerHTML = "他不知道" else $('#message')[0].innerHTML = "他知道"
	fetch-number(3, (text) !->
		enable-all-other-button 3
		if not is-fail
			number(3).innerHTML = text
			sum += parse-int text
			handle-result null, sum, order, position+1
		else
			handle-result 'D failed!', sum, order, position+1
	);

eHandler = (sum, order, position, handle-result) !->
	if button(4).classList.contains 'disable' or button(4).classList.contains 'waiting' then return
	button(4).classList.remove 'enable'
	button(4).classList.add 'disable'
	disable-all-other-buttons 4
	show-number-area 4
	is-fail = is-failed!
	if not is-fail then $('#message')[0].innerHTML = "才怪" else $('#message')[0].innerHTML = "才不怪"
	fetch-number(4, (text) !->
		enable-all-other-button 4
		if not is-fail
			number(4).innerHTML = text
			sum += parse-int text
			handle-result null, sum, order, position+1
		else
			handle-result 'E failed!', sum, order, position+1
	);

at-plus = ->
	atplus = $('#at_plus')[0]

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

show-order = (order) !->
	E_letter = ['A' to 'E']
	$("p")[0].innerHTML = ""
	for i in order
		$("p")[0].innerHTML += E_letter[i]