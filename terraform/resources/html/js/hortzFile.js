function myFunction() {
    var xmlHttp = new XMLHttpRequest();
    data = {
       id: "1",
       user: "gmargossian"
    }
    fetch("${API_ENDPOINT}/users", {
       method: 'POST', // or 'PUT'
       body: JSON.stringify(data), // data can be `string` or {object}!
       headers:{
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*'
       }
    }).then(function(response) {
       return response.text()
    }).then(function(data) {
       const msg = "the lambda returned " + data
       alert(msg);
       console.log(data);
    }).catch(function() {
       alert("Booo");
       console.log("Booo");
    });
}