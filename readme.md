# FEVER2.0 builder API

The FEVER2.0 shared task requires builders to submit Docker images (via dockerhub) as part of the competition to allow 
for adversarial evaluation. Images will host a web server using this package.
## Installation

```bash
pip install fever-api
```

## Example

See the [fever2-sample](https://github.com/j6mes/fever2-sample) repo

## Entrypoint
The submission must run a flask web server. In our application, the entrypoint is a function called `my_sample_fever` in the module `sample_application` (see `sample_application.py`).
The `my_sample_fever` function is a factory that returns a `fever_web_api` object. 

``` python
from fever.api.web_server import fever_web_api

def my_sample_fever():
    # Set up and initialize model
    ...
    
    # A prediction function that is called by the API
    def baseline_predict(instances):
        predictions = []
        for instance in instances:
            predictions.append(...prediction for instance...)
        return predictions

    return fever_web_api(baseline_predict)
```

Your dockerfile can then use the `flask run` method as the entrypoint, setting any valid factory as the `FLASK_APP`  

```dockerfile
ENV FLASK_APP sample_application:my_sample_fever
ENTRYPOINT ["flask","run"]
``` 


## Web Server
The web server is managed by the `fever-api` package. No setup or modification is required by participants. We use the default flask port of `5000` and host a single endpoint on `/predict`. We recommend using a client such as [Postman](https://www.getpostman.com/) to test your application.


```
POST /predict HTTP/1.1
Host: localhost:5000
Content-Type: application/json

{
	"instances":[
	    {"id":0,"claim":"this is a test claim"}, 
	    {"id":1,"claim":"this is another test claim"}, 
	]
}
```

## API
In our sample submission, we present a simple method `baseline_predict` method. 

```python 
   def baseline_predict(instances):
        predictions = []
        for instance in instances:
            ...prediction for instance...
            predictions.append({"predicted_label":"SUPPORTS", 
                                "predicted_evidence": [(Paris,0),(Paris,5)]})
            
        return predictions
```

Inputs: 

 * `instances` - a list of dictionaries containing a `claim` 

Outputs:

 * A list of dictionaries containing `predicted_label` (string in SUPPORTS/REFUTES/NOT ENOUGH INFO) and `predicted_evidence` (list of `(page_name,line_number)` pairs as defined in [`fever-scorer`](https://github.com/sheffieldnlp/fever-scorer).
