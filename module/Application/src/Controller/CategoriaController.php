<?php

namespace Application\Controller;

use Application\Model\Categoria;
use Application\Model\CategoriaRepository;
use Laminas\Mvc\Controller\AbstractActionController;
use Laminas\View\Model\ViewModel;

class CategoriaController extends AbstractActionController
{
    private $categoriaRepository;

    public function __construct(CategoriaRepository $categoriaRepository)
    {
        $this->categoriaRepository = $categoriaRepository;
    }

    public function indexAction()
    {
        $data = $this->categoriaRepository->findAll();
        $categorias = [];
        
        foreach ($data as $row) {
            $categorias[] = new Categoria($row);
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
                $this->categoriaRepository->insert($nombre, $descripcion);
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
        
        $data = $this->categoriaRepository->findById($id);
        
        if (!$data) {
            return $this->redirect()->toRoute('categoria');
        }
        
        $categoria = new Categoria($data);
        
        $request = $this->getRequest();
        if ($request->isPost()) {
            $nombre = $request->getPost('nombre', '');
            $descripcion = $request->getPost('descripcion', '');
            
            if (!empty($nombre)) {
                $this->categoriaRepository->update($id, $nombre, $descripcion);
            }
            
            return $this->redirect()->toRoute('categoria');
        }
        
        return new ViewModel(['categoria' => $categoria]);
    }

    public function deleteAction()
    {
        $id = (int) $this->params()->fromRoute('id', 0);
        
        if ($id !== 0) {
            $this->categoriaRepository->delete($id);
        }
        
        return $this->redirect()->toRoute('categoria');
    }
}