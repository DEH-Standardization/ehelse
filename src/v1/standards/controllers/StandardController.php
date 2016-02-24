<?php
require_once __DIR__ . '/../../iController.php';
require_once __DIR__ . '/../../main/controllers/DescriptionController.php';
require_once 'StandardVersionController.php';
require_once 'StandardFieldController.php';

class StandardController implements iController
{
    /*
     * Possibilities:
     *
     * .../standards
     * --method GET/POST
     *
     * .../standards/<id>
     * --return specific std
     *
     * .../standards/<id>/versions/...
     * --continue to version controller
     */

    private $method, $body, $path, $controller, $standard_id;

    public function __construct($path, $method, $body)
    {
        $this->method = $method;
        $this->body = $body;
        $this->path = $path;




        if(count($path) >= 1 && $path[0] == 'fields'){
            echo print_r($path);
            $this->trimPath(1);
            $this->controller = new StandardFieldController($this->path,$this->method,$this->body);
        }
        elseif(count($path) == 1){
            //check if number, if not return error
            if(is_numeric($path[0])){
                $this->standard_id = $path[0];
            }else{
                $this->controller = new DescriptionController();//return error
            }
        }elseif(count($path) >= 2){
            //check if number, if not return error
            if(is_numeric($path[0])){
                $this->standard_id = $path[0];

                if($path[1] == 'versions'){
                    //send to StandardVersionController
                    $this->trimPath(2);
                    $this->controller = new StandardVersionController($this->path,$this->method,$this->body,$this->standard_id);
                }else{
                    $this->controller = new DescriptionController();//return error
                }
            }else{
                $this->controller = new DescriptionController();//return error
            }
        }
    }

    //if $parts == 1,then remove std_id, if $parts == 2, then remove std_id AND 'verions'
    private function trimPath($parts){
        if($parts == 1){
            //remove part from path array and fix index of array
            unset($this->path[0]);
            $this->path = array_values($this->path);

        }elseif($parts == 2){
            //remove part from path array and fix index of array
            unset($this->path[0]);
            unset($this->path[1]);
            $this->path = array_values($this->path);
        }
    }

    private function getStandard()
    {
        return "Return standard";
    }

    private function updateStandard()
    {
        return "Standard, standard updated";
    }

    private function deleteStandard()
    {
        return "Sd deleted";
    }

    private function handleStandardRequest()
    {
        $response = null;
        switch($this->method){
            case "GET":
                $response = $this->getStandard();
                break;
            case "POST":
                $response = "Error not suposed to post here";
                break;
            case "PUT":
                $response = $this->updateStandard();
                break;
            case "DELETE":
                $response = $this->deleteStandard();
                break;
        }
        return $response;
    }

    public function getResponse()
    {
        $response = null;

        if(!is_null($this->controller)){
            //got controller? if so, use its getResponse.
            $response = $this->controller->getResponse();

        }elseif(is_null($this->controller) && !is_null($this->standard_id)){
            //TODO if not controller, but standard_id, then return the json for THAT standard.
            $response = $this->handleStandardRequest();

        }else{
            //TODO if neither, return a list with all standards.
            //if method == GET: return ALL standards
            //if method == POST: create new standard using body
            if($this->method == 'POST'){
                $response = 'I created a new std!';
            }elseif($this->method == 'GET'){
                $response = 'I returned all the stds!';
            }
        }
        return $response;
        //return json_encode($this->body);
    }
}