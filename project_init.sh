GIT="https://github.com/"
PROJECT_ROOT=$(pwd)
TORCH_VERSION=$(pip show torch | grep Version)
CUDA_VERSION=$(ls /usr/local/ | grep "cuda-" | sed "s/cuda-//")
COCO_PATH="datasets/coco"
MOUNT_PATH="/media/pjh3974"

GIT_FETCH(){
	cd $1
	git fetch origin
	git checkout -q -b renewal origin/renewal
	cd "${PROJECT_ROOT}"
}

if [[ -z ${TORCH_VERSION} ]]; then
	conda install pytorch torchvision torchaudio cudatoolkit=11.0 -c pytorch
fi

# setup fvcore

cd ${PROJECT_ROOT}

if [[ ! -e "fvcore" ]]; then
	git clone "${GIT}JunhoPark0314/fvcore.git"
	$(GIT_FETCH "fvcore")
	pip install -e fvcore
fi

if [[ ! -e "fvcore" ]]; then
	git clone "${GIT}JunhoPark0314/fvcore.git"
	$(GIT_FETCH "fvcore")
	pip install -e fvcore
fi

if [[ ! -e "detectron2" ]]; then
	git clone "${GIT}JunhoPark0314/detectron2.git"
	$(GIT_FETCH "detectron2")
	pip install -e detectron2
fi

if [[ ! -e "PAA" ]]; then
	git clone "${GIT}JunhoPark0314/PAA.git"
	$(GIT_FETCH "PAA")
	cd PAA
	pip install -r requirements.txt
	python setup.py build develop --no-deps
	cd ${PROJECT_ROOT}
fi

if [[ ! -e "AdelaiDet" ]]; then
	git clone "${GIT}JunhoPark0314/AdelaiDet.git"
	$(GIT_FETCH "AdelaiDet")
	pip install -e AdelaiDet
	sudo apt-get install -y libgl1-mesa-glx libglib2.0-0
	pip install sklearn
fi


if [[ ! -e "cocoapi" ]]; then
	git clone "${GIT}JunhoPark0314/cocoapi.git"
	$(GIT_FETCH "cocoapi")
	cd cocoapi/PythonAPI
	pip install cython
	make install
	cd ${PROJECT_ROOT}
fi

mkdir -p /media/pjh3974/datasets
mkdir -p /media/pjh3974/output/detectron2
mkdir -p /media/pjh3974/output/AdelaiDet

if [[ ! -e "detectron2/$COCO_PATH" ]]; then
	ln -s "$MOUNT_PATH/$COCO_PATH" detectron2/$COCO_PATH 
fi

if [[ ! -e "detectron2/output" ]]; then
	ln -s "$MOUNT_PATH/output/detectron2" detectron2/output
fi


if [[ ! -e "AdelaiDet/$COCO_PATH" ]]; then
	ln -s "$MOUNT_PATH/$COCO_PATH" AdelaiDet/$COCO_PATH 
fi

if [[ ! -e "AdelaiDet/output" ]]; then
	ln -s "$MOUNT_PATH/output/AdelaiDet" AdelaiDet/output
fi

