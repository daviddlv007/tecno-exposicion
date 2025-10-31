<?php

namespace Application\Model;

use PDO;

class CategoriaRepository
{
    private $pdo;

    public function __construct(PDO $pdo)
    {
        $this->pdo = $pdo;
        $this->initializeDatabase();
    }

    /**
     * Inicializa la base de datos y crea la tabla si no existe
     */
    private function initializeDatabase()
    {
        $sql = "
            CREATE TABLE IF NOT EXISTS categorias (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                nombre TEXT NOT NULL,
                descripcion TEXT,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
            )
        ";
        
        $this->pdo->exec($sql);
    }

    /**
     * Obtiene todas las categorías
     */
    public function findAll()
    {
        $stmt = $this->pdo->query("SELECT * FROM categorias ORDER BY id DESC");
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    /**
     * Obtiene una categoría por ID
     */
    public function findById($id)
    {
        $stmt = $this->pdo->prepare("SELECT * FROM categorias WHERE id = ?");
        $stmt->execute([$id]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    /**
     * Inserta una nueva categoría
     */
    public function insert($nombre, $descripcion = '')
    {
        $stmt = $this->pdo->prepare("
            INSERT INTO categorias (nombre, descripcion)
            VALUES (?, ?)
        ");
        
        $stmt->execute([$nombre, $descripcion]);
        return $this->pdo->lastInsertId();
    }

    /**
     * Actualiza una categoría existente
     */
    public function update($id, $nombre, $descripcion = '')
    {
        $stmt = $this->pdo->prepare("
            UPDATE categorias 
            SET nombre = ?, descripcion = ?, updated_at = CURRENT_TIMESTAMP
            WHERE id = ?
        ");
        
        return $stmt->execute([$nombre, $descripcion, $id]);
    }

    /**
     * Elimina una categoría
     */
    public function delete($id)
    {
        $stmt = $this->pdo->prepare("DELETE FROM categorias WHERE id = ?");
        return $stmt->execute([$id]);
    }
}
