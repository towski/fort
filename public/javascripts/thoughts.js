function get_current_thought(get_thought){
	var ul = document.getElementById('thoughts')
	ul.innerHTML = ""
	var request = new XMLHttpRequest()
	var url = '/triforce/thoughts'
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
	var thought = JSON.parse(thought)
	var ul = document.getElementById('thoughts')
	var li = document.createElement('li')//		<li id='thought-5' >
	li.id = 'thought-' + i
	ul.appendChild(li)
	var p = document.createElement('p')//		<li id='thought-5' >
	p.className = "thought-text"
	p.innerHTML = thought.body
	li.appendChild(p)
	var a = document.createElement('a')//		<li id='thought-5' >
	a.title = thought.time
	li.appendChild(a)
	var span = document.createElement('span')//		<li id='thought-5' >
	span.innerHTML = '<a href="https://twitter.com/share" data-url="http://" class="xtwitter-share-button" data-text="something" data-related="towski" data-count="none" onclick="clickShare(event.target, \'thought-' + i +'\'); return false">Share</a>'
	span.style['margin-left'] = '20px'
	li.appendChild(span)
}

function clickShare(button1, thought_id){
	button1.className = 'twitter-share-button'
	var thought = document.getElementById(thought_id);
	var text = thought.querySelector('p')
	if(document.location.hostname == "localhost"){
		button1.setAttribute('data-text', text.innerText)
	} else {
		button1.setAttribute('data-text', "RT @towski " + text.innerText)
	}
	setupButton()
}

function setupButton(){
	!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');
}

get_current_thought()
