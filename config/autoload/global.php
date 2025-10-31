<?php

return [
    'service_manager' => [
        'factories' => [
            'Router' => \Laminas\Router\RouterFactory::class,
            'HttpRouter' => function() {
                $router = new \Laminas\Router\Http\TreeRouteStack();
                $router->addRoutes([]);
                return $router;
            },
        ],
    ],
];