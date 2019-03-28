import logging
from logging.config import dictConfig

from flask import Flask, request
from flask_responses import json_response


def wrap_message(status,data):
    return {"result":status,"data":data}


def wrap_error(message):
    return wrap_message("error", {"message":message})


def wrap_predictions(predictions):
    return wrap_message("success", {"predictions":predictions})


class FEVERRequestInstance(dict):
    def __init__(self, **data):
        super().__init__(**data)


def fever_web_api(predict_function):
    app = Flask(__name__)
    app.logger.info("Init FEVER API web application")

    @app.route("/predict", methods=["POST"])
    def predict():
        if request.json is None:
            return json_response(wrap_error("Expected a JSON request"), 400)

        if "instances" not in request.json or request.json["instances"] is None:
            return json_response(wrap_error("The request body did not contain any instances"), 400)

        try:
            iter(request.json["instances"])
        except TypeError:
            return json_response(wrap_error("The instances field is not iterable"), 400)

        if isinstance(request.json["instances"], str):
            return json_response(wrap_error("Instances field must not be a string"), 400)

        instances = []
        if all(map(lambda instance: isinstance(instance, str), request.json["instances"])):
            instances.extend([FEVERRequestInstance(**{"id":idx,"claim":instance}) for idx, instance in enumerate(request.json["instances"])])
        elif all(map(lambda instance: "id" in instance
                                      and "claim" in instance
                                      and isinstance(instance["id"], int)
                                      and isinstance(instance["claim"], str), request.json["instances"])):
            instances.extend([FEVERRequestInstance(**instance) for instance in request.json["instances"]])
        else:
            return json_response(wrap_error("Instances field must contain a list of strings or objects containing 'id':int and 'claim':str fields"), 400)

        app.logger.info("Predicting with {} instances".format(len(instances)))
        predictions = predict_function(instances)

        for prediction, instance in zip(predictions,instances):
            prediction["request_instance"] = instance

        app.logger.info("Predicting complete")

        return json_response(wrap_predictions(predictions))

    return app


def sample_application(*args):
    def predict_fuction(instances):
        return [{"predicted_label":"NOT ENOUGH INFO", "predicted_evidence":[]} for _ in instances]

    print("sample application")

    return fever_web_api(predict_fuction)
