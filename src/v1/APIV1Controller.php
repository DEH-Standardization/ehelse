<?php

require_once 'iController.php';
require_once 'documents/controllers/DocumentController.php';
require_once 'topics/controllers/TopicController.php';
require_once 'login/controllers/LoginController.php';

class APIV1Controller implements iController
{
    private $controller;

    public function __construct($path, $method, $body)
    {
        $part = $path[0];
        $path = trimPath($path, 1);
        switch($part)
        {
            case 'documents':
                $this->controller = new DocumentController($path, $method, $body);
                break;
            case 'topics':
                $this->controller = new TopicController($path, $method, $body);
                break;
            case 'login':
                $this->controller = new LoginController($path, $method, $body);
                break;
            default:
                $this->controller = new ErrorController(new InvalidPathError());
                break;
        }
    }

    public function getResponse()
    {
        return $this->controller->getResponse();
    }
}