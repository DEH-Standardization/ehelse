<?php

require_once __DIR__ . "/../EHelseDatabaseTestCase.php";
require_once __DIR__ . "/../EHelseTestCase.php";
require_once __DIR__ . "/../../../src/v1/status/StatusController.php";
require_once __DIR__ . "/../../../src/v1/errors/AuthenticationError.php";
require_once __DIR__ . "/../../../src/v1/errors/NotFoundError.php";
require_once __DIR__ . "/../../../src/v1/errors/AuthorizationError.php";

class StatusControllerTest extends EHelseDatabaseTestCase
{
    const list_name = "status";
    const fields = ["id", "name", "description"];
    public function test_get_all_statuses_on_empty_table_returns_empty_array()
    {
        $this->mySetup(__DIR__ . "/empty_status_table.xml");
        $controller = new StatusController([], Response::REQUEST_METHOD_GET, array());
        $response = $controller->getResponse();

        self::assertIsValidResponseList($response);
    }

    public function test_get_all_statuses_on_basic_table_returns_statues()
    {
        $this->mySetup(__DIR__ . "/basic_status_table.xml");
        $controller = new StatusController([], Response::REQUEST_METHOD_GET, array());
        $response = $controller->getResponse();

        self::assertIsValidResponseList($response);
    }

    public function test_get_status_on_empty_table_returns_error()
    {
        $this->mySetup(__DIR__ . "/empty_status_table.xml");
        $controller = new StatusController([1], Response::REQUEST_METHOD_GET, array());
        $response = $controller->getResponse();
        self::assertIsValidErrorResponse($response, Response::STATUS_CODE_NOT_FOUND);
    }

    public function test_get_status_on_basic_table_returns_status()
    {
        $this->mySetup(__DIR__ . "/basic_status_table.xml");
        $controller = new StatusController([1], Response::REQUEST_METHOD_GET, array());
        $response = $controller->getResponse();
        self::assertIsValidResponse($response);
    }


    public function test_delete_status_returns()
    {
        $this->mySetup(__DIR__ . "/basic_status_table.xml");
        $controller = new StatusController([1], Response::REQUEST_METHOD_DELETE, array());
        $response = $controller->getResponse();
        self::assertIsValidDeleteResponse($response);
    }

    public function test_update_status_updated_status()
    {
        $this->mySetup(__DIR__ . "/basic_status_table.xml");
        $new_data = [
            "id" => 1,
            "name" => "123",
            "description" => "321"
        ];
        $controller = new StatusController([1], Response::REQUEST_METHOD_PUT, $new_data);
        $response = $controller->getResponse();
        self::assertIsValidResponse($response);

        self::assertIsCorrectResponseData($response->getBody(), $new_data);
    }

    public function test_post_status_creates_status()
    {
        $this->mySetup(__DIR__ . "/basic_status_table.xml");
        $new_data = [
            "name" => "derp",
            "description" => "pred"
        ];
        $controller = new StatusController([], Response::REQUEST_METHOD_POST, $new_data);
        $response = $controller->getResponse();
        self::assertIsValidResponse($response, Response::STATUS_CODE_CREATED);

        self::assertIsCorrectResponseData($response->getBody(), $new_data);
    }
}