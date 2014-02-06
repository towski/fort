function get_current_thought(get_thought){
	var ul = document.getElementById('thoughts')
	ul.innerHTML = ""
	var request = new XMLHttpRequest()
	var url = '/fort/thoughts'
	request.open('get', url) 
	request.onload = function() {
		if (this.status == 200 || this.status == 304){ 
			var thoughts = JSON.parse(this.responseText)
			for(var index in thoughts){
				window.get_thought(thoughts[index], index)
			}
			window.prettyLinks()
		}
	}
	request.send()
}

function get_thought(thought, i){
	var ul = document.getElementById('thoughts')
	var li = document.createElement('li')
	li.id = 'thought-' + i
	ul.appendChild(li)
	var p = document.createElement('p')
	p.className = "thought-text"
	p.innerHTML = thought.body
	li.appendChild(p)
	var a = document.createElement('a')
	a.title = thought.time
	li.appendChild(a)
	var span = document.createElement('span')
	span.innerHTML = '<a href="https://twitter.com/share" data-url="http://" class="xtwitter-share-button" data-text="something" data-related="towski" data-count="none" onclick="clickShare(event.target, \'thought-' + i +'\'); return false">Share</a>'
	span.style['margin-left'] = '20px'
	li.appendChild(span)
	if(document.location.hostname == "localhost"){
		var a = document.createElement('a')
		a.innerHTML = 'edit'
		a.href = "/fort/edit/" + thought.id
		a.onclick = safe_function(function(){
			query('//*[@id="thought-'+ i +'"]/p', add_form_to_thought.bind(thought))
		})
		a.style['margin-left'] = '10px'
		li.appendChild(a)
	}
}

function safe_function(callback){
	return function(){
		try {
			console.log("try")
			callback()
		} catch(e){
			console.log(e)
			errors.push(e)
		}
		return false
	}
}

errors = []

function add_form_to_thought(element){
	element.innerHTML = ""
	var form = document.createElement('form')
	form.action = '/fort/thoughts/' + this.id
	form.method = "post"
	var input = document.createElement('textarea')
	input.innerHTML = this['body']
	input.name = "body"
	input.rows = 3
	input.cols = 50
	form.appendChild(input)
	var input = document.createElement('input')
	input.type = "submit"
	form.appendChild(input)
	element.appendChild(form)
}

function clickShare(button1, thought_id){
	button1.style.display = 'none'
	button1.className = 'twitter-share-button'
	var thought = document.getElementById(thought_id);
	var text = thought.querySelector('p')
	if(document.location.hostname == "localhost"){
		button1.setAttribute('data-text', text.innerText)
	} else {
		button1.setAttribute('data-text', "RT @towski " + text.innerText)
	}
	var facebook_link = document.createElement('a')
	facebook_link.innerHTML = " facebook"
	facebook_link.href = "#"
	facebook_link.onclick = function(message){
		return function(){
			post_to_facebook(message)
			return false;
		}
	}(text.innerText)
	text.parentNode.appendChild(facebook_link)
	setupButton()
}

function setupButton(){
	!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');
}

get_current_thought()
