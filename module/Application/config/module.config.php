<?php

namespace Application;

use Application\Controller\CategoriaController;
use Laminas\Router\Http\Literal;
use Laminas\Router\Http\Segment;

return [
    'router' => [
        'routes' => [
            'home' => [
                'type' => Literal::class,
                'options' => [
                    'route' => '/',
                    'defaults' => [
                        'controller' => CategoriaController::class,
                        'action' => 'index',
                    ],
                ],
            ],
            'categoria' => [
                'type' => Segment::class,
                'options' => [
                    'route' => '/categoria[/:action[/:id]]',
                    'constraints' => [
                        'action' => '[a-zA-Z][a-zA-Z0-9_-]*',
                        'id' => '[0-9]+',
                    ],
                    'defaults' => [
                        'controller' => CategoriaController::class,
                        'action' => 'index',
                    ],
                ],
            ],
        ],
    ],
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
    'controllers' => [
        'invokables' => [
            CategoriaController::class => CategoriaController::class,
        ],
    ],
    'view_manager' => [
        'display_not_found_reason' => true,
        'display_exceptions' => true,
        'doctype' => 'HTML5',
        'not_found_template' => 'error/404',
        'exception_template' => 'error/index',
        'template_map' => [
            'layout/layout' => __DIR__ . '/../view/layout/layout.phtml',
            'error/404' => __DIR__ . '/../view/error/404.phtml',
            'error/index' => __DIR__ . '/../view/error/index.phtml',
        ],
        'template_path_stack' => [
            __DIR__ . '/../view',
        ],
    ],
];