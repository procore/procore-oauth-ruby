var logResponse = function (http) {
  return function() {
    console.info('per-page ->', parseInt(http.getResponseHeader('per-page')))
    element = document.getElementById('api-log')
    element.className = 'api-response code prettyprint lang-js'
    element.innerHTML = http.responseText
  }
}

var apiRequest = function(path, method) {
  method = method || 'GET'
  path = path || '/vapid/companies'
  console.info(method, apiUrl + path)
  var httpRequest = new XMLHttpRequest()
  httpRequest.open(method, apiUrl + path, true)
  httpRequest.setRequestHeader('Authorization', 'Bearer '+ localStorage.getItem('accessToken'))
  httpRequest.onreadystatechange = logResponse(httpRequest)
  httpRequest.send(null)
}

apiRequest('/vapid/companies')
