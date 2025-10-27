<?php

namespace Application\Controller;

use Application\Model\Categoria;
use Laminas\Mvc\Controller\AbstractActionController;
use Laminas\View\Model\ViewModel;

class CategoriaController extends AbstractActionController
{
    public function indexAction()
    {
        $categorias = [];
        foreach ($_SESSION['categorias'] as $data) {
            $categorias[] = new Categoria($data);
        }
        
        return new ViewModel(['categorias' => $categorias]);
    }

    public function addAction()
    {
        $request = $this->getRequest();
        
        if ($request->isPost()) {
            $nombre = $request->getPost('nombre', '');
            $descripcion = $request->getPost('descripcion', '');
            
            if (!empty($nombre)) {
                $_SESSION['categorias'][] = [
                    'id' => $_SESSION['next_id']++,
                    'nombre' => $nombre,
                    'descripcion' => $descripcion
                ];
            }
            
            return $this->redirect()->toRoute('categoria');
        }
        
        return new ViewModel();
    }

    public function editAction()
    {
        $id = (int) $this->params()->fromRoute('id', 0);
        
        if ($id === 0) {
            return $this->redirect()->toRoute('categoria');
        }
        
        $categoria = null;
        foreach ($_SESSION['categorias'] as $data) {
            if ($data['id'] == $id) {
                $categoria = new Categoria($data);
                break;
            }
        }
        
        if (!$categoria) {
            return $this->redirect()->toRoute('categoria');
        }
        
        $request = $this->getRequest();
        if ($request->isPost()) {
            $nombre = $request->getPost('nombre', '');
            $descripcion = $request->getPost('descripcion', '');
            
            foreach ($_SESSION['categorias'] as &$data) {
                if ($data['id'] == $id) {
                    $data['nombre'] = $nombre;
                    $data['descripcion'] = $descripcion;
                    break;
                }
            }
            
            return $this->redirect()->toRoute('categoria');
        }
        
        return new ViewModel(['categoria' => $categoria]);
    }

    public function deleteAction()
    {
        $id = (int) $this->params()->fromRoute('id', 0);
        
        if ($id !== 0) {
            $_SESSION['categorias'] = array_filter($_SESSION['categorias'], function($data) use ($id) {
                return $data['id'] != $id;
            });
        }
        
        return $this->redirect()->toRoute('categoria');
    }
}