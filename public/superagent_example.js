superagent
  .get(apiUrl+'/vapid/companies')
  .set('Authorization', 'Bearer '+ localStorage.getItem('accessToken'))
  .set('Content-Type', 'application/json')
  .set('Accept', 'application/json')
  .end(function(err, res){
    if (err || !res.ok) {
      console.error('Oh no! superagent error: ', err);
    } else {
      console.log('superagent response status   -> ', res.status);
      console.log('super agent response headers -> ', res.header);
      console.log('superagent response body     -> ', res.body);
    }
  });
