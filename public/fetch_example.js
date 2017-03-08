function callApi(path, method, data) {
  method = method || 'get'
  let url = `${apiUrl}${path}`
  let headers = new Headers()
  headers.append('Accept', 'application/json')
  headers.append('Authorization', 'Bearer '+ localStorage.getItem('accessToken'))
  console.debug(` --> start ${method} ${url}`)
  return fetch( url, {
    method: method,
    headers: headers,
    mode: 'cors'
  })
  .then(function(response) {
    console.log(response)
    return response.json().then(function(json){
      console.debug('done', method, path, ' | ', json)
      return json
    })
  })
  .catch(function(err){console.error(`api error while trying: ${method} ${url} `, err)})
}

callApi('/vapid/companies')
.then(function(companies) {
  companies.map(function(company) {
    document.getElementById('api-log').innerHTML = JSON.stringify(company,null, '\t')
    console.log(`getting more details for company ${company.id}, ${company.name}`)
    console.log(`/vapid/analytic_events?company_id=${company.id}&key=project_area.drawings.changed_markup_tool_arrow_group`);
    callApi(`/vapid/analytic_events?company_id=${company.id}&key=project_area.drawings.changed_markup_tool_arrow_group`  , 'post')

    // callApi(`/vapid/companies/${company.id}`)
    // callApi(`/vapid/users?company_id=${company.id}`)
    // callApi(`/vapid/projects?company_id=${company.id}`)
  })
})
