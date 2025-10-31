<?php

namespace Application\Service;

use Application\Model\Categoria;

/**
 * Servicio para gestionar la lógica de negocio de categorías
 * Separación de responsabilidades según arquitectura Laminas
 */
class CategoriaService
{
    /**
     * Obtiene todas las categorías con validación de negocio
     *
     * @return array
     */
    public function getAllCategorias()
    {
        $categorias = Categoria::getAll();
        
        // Aquí podrías agregar lógica de negocio como:
        // - Filtros
        // - Validaciones
        // - Transformaciones
        // - Logging
        
        return $categorias;
    }
    
    /**
     * Valida los datos de una categoría antes de guardar
     *
     * @param array $data
     * @return array Errores de validación
     */
    public function validateCategoria($data)
    {
        $errors = [];
        
        if (empty($data['nombre'])) {
            $errors[] = 'El nombre es requerido';
        }
        
        if (strlen($data['nombre']) > 100) {
            $errors[] = 'El nombre no puede exceder 100 caracteres';
        }
        
        return $errors;
    }
    
    /**
     * Procesa la creación de una nueva categoría
     *
     * @param array $data
     * @return bool
     */
    public function createCategoria($data)
    {
        $errors = $this->validateCategoria($data);
        
        if (!empty($errors)) {
            return false;
        }
        
        return Categoria::create($data);
    }
}