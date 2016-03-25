<?php

require_once __DIR__ . '/../../dbmappers/UserDBMapper.php';
require_once __DIR__ . '/../../errors/NotFoundError.php';

class UserController extends ResponseController
{

    public function __construct($path, $method, $body)
    {
        $this->body = $body;
        $this->method=$method;
        $this->path = $path;

        if(count($this->path) != 0){
            if(count($this->path) == 1 && is_numeric($path[0])){
                $this->id = $path[0];
            }else{
                $this->controller = new ErrorController(new InvalidPathError());
            }
        }

    }

    protected static function getArrayFromObjectArray($array){
        $return_array = [];
        foreach($array as $item){
            array_push($return_array, $item->toArray());
        }
        return $return_array;
    }

    protected function getAll()
    {
        $mapper = new UserDBMapper();
        $users = $mapper->getAll();
        $users_array = UserController::getArrayFromObjectArray($users);

        $json = json_encode(array( "users" => $users_array), JSON_PRETTY_PRINT);

        return new Response($json);
    }

    protected function create()
    {
        $missing_fields = UserController::validateJSONFormat($this->body, User::REQUIRED_POST_FIELDS);
        if( !$missing_fields ){
            $mapper = new UserDBMapper();
            $user = User::fromJSON($this->body);
            $db_response = $mapper->add($user);

            if ($db_response instanceof DBError) {
                $response = new ErrorResponse($db_response);
            }
            elseif(is_numeric($db_response)){
                $this->id = $db_response;
                $response = $this->get();
            }
            else{
                //todo not sure how best to handle this
                throw new Exception("Not implemented error");
            }
        }
        else{
            $response = new ErrorResponse(new MalformedJSONFormatError($missing_fields));
        }
        return $response;
    }

    protected function get()
    {
        $mapper = new UserDBMapper();
        $user = $mapper->getById($this->id);
        if($user){
            $response = new Response(json_encode($user->toArray(), JSON_PRETTY_PRINT));
        }
        else{
            $response = new ErrorResponse(new NotFoundError());
        }
        return $response;
    }

    protected function update()
    {
        // TODO: Implement update() method.
    }

    protected function delete()
    {
        // TODO: Implement delete() method.
    }
}