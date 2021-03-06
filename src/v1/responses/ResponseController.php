<?php
require_once __DIR__ . "/../iController.php";
require_once __DIR__ . "/../../v1/errors/MethodNotAllowedError.php";
require_once __DIR__ . "/ErrorResponse.php";

abstract class ResponseController implements iController
{
    protected $method, $body, $path, $controller, $id, $db_mapper, $list_name, $model;

    /**
     * Returns all elements from model
     * @return Response
     */
    protected function getAll()
    {
        $mapper = new $this->db_mapper();
        $objects = $mapper->getAll();
        $object_array = [];
        foreach ($objects as $object) {
            array_push($object_array, $object->toArray());
        }

        $json = json_encode(array($this->list_name => $object_array), JSON_PRETTY_PRINT);

        return new Response($json);
    }

    /**
     * Add new element to database
     * @return ErrorResponse|Response
     * @throws Exception
     */
    protected function create()
    {
        $model = $this->model;
        $missing_fields = self::validateJSONFormat($this->body, $model::REQUIRED_POST_FIELDS);

        // Check that required fields are not missing
        if (!$missing_fields) {
            $mapper = new $this->db_mapper();
            $object = $model::fromJSON($this->body);
            $db_response = $mapper->add($object);

            if ($db_response instanceof DBError) {
                $response = new ErrorResponse($db_response);
            } elseif (is_numeric($db_response)) {
                $this->id = $db_response;
                $response = $this->get();
                $response->setResponseCode(Response::STATUS_CODE_CREATED);
            } else {
                throw new Exception("Not implemented error");
            }
        } else {
            $response = new ErrorResponse(new MalformedJSONFormatError($missing_fields));
        }
        return $response;
    }

    /**
     * Returns "{}"
     * @return Response
     */
    protected function getOptions()
    {
        return new Response("{}");
    }

    /**
     * Returns element
     * @return ErrorResponse|Response
     */
    protected function get()
    {
        $mapper = new $this->db_mapper();
        $object = $mapper->getById($this->id);
        if ($object) {
            $response = new Response(json_encode($object->toArray(), JSON_PRETTY_PRINT));
        } else {
            $response = new ErrorResponse(new NotFoundError());
        }
        return $response;
    }

    /**
     * Updates element
     * @return ErrorResponse|Response
     */
    protected function update()
    {
        $model = $this->model;
        $missing_fields = self::validateJSONFormat($this->body, $model::REQUIRED_PUT_FIELDS);

        // Check that required fields are not missing
        if (!$missing_fields) {
            $mapper = new $this->db_mapper();
            $json = $this->body;
            $json["id"] = $this->id;
            $object = $model::fromJSON($json);
            $db_response = $mapper->update($object);

            if ($db_response instanceof DBError) {
                $response = new ErrorResponse($db_response);
            } else {
                $response = $this->get();
            }
        } else {
            $response = new ErrorResponse(new MalformedJSONFormatError($missing_fields));
        }

        return $response;
    }

    /**
     * Deletes elements
     * @return Response
     */
    protected function delete()
    {
        $db_mapper = new $this->db_mapper();
        $response = $db_mapper->deleteById($this->id);
        return new Response(json_encode("{}", JSON_PRETTY_PRINT), Response::STATUS_CODE_NO_CONTENT);
    }

    /**
     * Choose method based on HTTP request method
     * @return ErrorResponse|null|Response
     */
    protected function handleRequest()
    {
        $response = null;
        switch ($this->method) {
            case Response::REQUEST_METHOD_GET:
                $response = $this->get();
                break;
            case Response::REQUEST_METHOD_PUT:
                $response = $this->update();
                break;
            case Response::REQUEST_METHOD_DELETE:
                $response = $this->delete();
                break;
            case Response::REQUEST_METHOD_OPTIONS:
                $response = $this->getOptions();
                break;
            default:
                $response = new ErrorResponse(new MethodNotAllowedError(Response::REQUEST_METHOD_POST));
                break;
        }
        return $response;
    }

    /**
     * Returns response
     * @return ErrorResponse|null|Response
     * @throws Exception
     */
    public function getResponse()
    {
        $response = null;

        if (!is_null($this->controller)) {
            $response = $this->controller->getResponse();

        } elseif (is_null($this->controller) && !is_null($this->id)) {
            $response = $this->handleRequest();

        } else {
            if ($this->method == Response::REQUEST_METHOD_POST) {
                $response = $this->create();
            } elseif ($this->method == Response::REQUEST_METHOD_GET) {
                $response = $this->getAll();
            } elseif ($this->method == Response::REQUEST_METHOD_OPTIONS) {
                $response = $this->getOptions();
            } else {
                $response = new ErrorResponse(new MethodNotAllowedError($this->method));
            }
        }
        return $response;
    }

    /**
     * Initializes path, body and method
     * @param $path
     * @param $method
     * @param $body
     */
    protected function init($path, $method, $body)
    {
        $this->method = $method;
        $this->body = $body;
        $this->path = $path;

        if (count($this->path) != 0) {
            if (count($this->path) == 1 && is_numeric($path[0])) {
                $this->id = $path[0];
            } else {
                $this->controller = new ErrorController(new InvalidPathError());
            }
        }
    }

    /**
     * Returns missing fields if any fields are missing from JSON
     * @param $json
     * @param $required_fields
     * @return array
     */
    protected static function validateJSONFormat($json, $required_fields)
    {
        $missing_fields = [];
        foreach ($required_fields as $required_field) {
            if (!array_key_exists($required_field, $json)) {
                array_push($missing_fields, $required_field);
            }
        }
        return $missing_fields;
    }
}