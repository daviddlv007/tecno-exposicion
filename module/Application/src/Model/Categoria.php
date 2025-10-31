<?php

namespace Application\Model;

class Categoria
{
    public $id;
    public $nombre;
    public $descripcion;

    public function __construct($data = [])
    {
        $this->id = $data['id'] ?? null;
        $this->nombre = $data['nombre'] ?? '';
        $this->descripcion = $data['descripcion'] ?? '';
    }
}