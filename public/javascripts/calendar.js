var hasOwnProperty = Object.prototype.hasOwnProperty;

function isEmpty(obj) {
  if (obj == null) return true;
  if (obj.length > 0)    return false;
  if (obj.length === 0)  return true;
  // Note that this doesn't handle
  // toString and valueOf enumeration bugs in IE < 9
  for (var key in obj) {
      if (hasOwnProperty.call(obj, key)) return false;
  }
  return true;
}

function pad(num, size) {
  var s = "000000000" + num;
  return s.substr(s.length-size);
}

function request_call(td, i, next_date){
  var request = new XMLHttpRequest()
  var url = '/journals/2014'.concat(pad((next_date.getMonth() + 1), 2), pad(next_date.getDate(), 2), '.html')
  request.open('head', url) 
  request.onload = function() {
    if (this.status == 200 || this.status == 304){ 
      td.innerHTML = "<a href='" + url + "'>" + i + "</a>"
    } else {
      td.innerHTML = i
    }
  }
  request.send()
}

var total_days = 28
var current_days = 0
var today = new Date()

function build_calendar(month, year, object){
  if(isEmpty(object)){
    var first_row = document.createElement('tr')
    object.first_row = first_row
    var first = true
  } else {
    var first_row = object.first_row
    var first = false
  }
  var first_day = new Date(year, month, 1)
  var new_element = document.createElement('div')
  var month_table = document.createElement('table')
  month_table.style.margin = "auto"
  new_element.appendChild(month_table)
  var blank_day = new Date(first_day.getFullYear(), first_day.getMonth() + 1, 0)
  // let me get this straight. new Date(year, month).getMonth() is different than the month that gets passed in?
  if(first_day.getMonth() == today.getMonth()){
    var i = today.getDate()
  } else {
    var i = blank_day.getDate()
  }
  var date_start = new Date(first_day.getFullYear(), first_day.getMonth(), i)
  var start_day = 6
  while(first && start_day > date_start.getDay()){
    var td = document.createElement('td')
    td.innerHTML = ""
    td.className = "month_day"
    td.className = "blank_day"
    first_row.appendChild(td)
    start_day -= 1
    current_days += 1
  }

  month_table.appendChild(first_row)
  var next_row = first_row
  while(i > 0){
    var next_date = new Date(first_day.getFullYear(), first_day.getMonth(), i)
    if(today.getMonth() == next_date.getMonth() && next_date.getDate() > today.getDate()){
      break;
    }
    var td = document.createElement('td')
    request_call(td, i, next_date)
    if (next_date.getDay() == 6){
      next_row = document.createElement('tr')
      month_table.appendChild(next_row)
    }
    if (next_date.getDate() == today.getDate() && next_date.getMonth() == next_date.getMonth()){
      td.className = "month_day today"
      //td.className = "month_day"
    } else {
      td.className = "month_day"
    }
    next_row.appendChild(td)
    month_table
    i -= 1
    current_days += 1
    if(current_days >= total_days){
      break 
    }
  }
  object.first_row = next_row
  return new_element;
}

var tr = document.getElementById('diary')
var month_name_header = document.createElement('h4')
month_name_header.style['text-align'] = "center"
month_name_header.innerHTML = "Diary"
tr.appendChild(month_name_header)
var first_row = Object()
var new_element = build_calendar(today.getMonth(), 2014, first_row)
tr.appendChild(new_element)
if(current_days < total_days){
  new_element = build_calendar(today.getMonth() - 1, 2014, first_row)
  tr.appendChild(new_element)
}
