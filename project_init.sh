GIT="https://github.com/"
PROJECT_ROOT="/home/sysadmin/projects"
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
	conda install pytorch torchvision torchaudio cudatoolkit=${CUDA_VERSION} -c pytorch
fi

# setup fvcore

cd ${PROJECT_ROOT}

if [[ -z "fvcore" ]]; then
	git clone "${GIT}JunhoPark0314/fvcore.git"
	pip install -e fvcore
fi

$(GIT_FETCH "fvcore")

if [[ -z "detectron2" ]]; then
	git clone "${GIT}JunhoPark0314/detectron2.git"
	pip install -e detectron2
fi

$(GIT_FETCH "detectron2")

if [[ -z "AdelaiDet" ]]; then
	git clone "${GIT}JunhoPark0314/AdelaiDet.git"
	pip install -e AdelaiDet
fi

$(GIT_FETCH "AdelaiDet")

if [[ -z "cocoapi" ]]; then
	git clone "${GIT}JunhoPark0314/cocoapi.git"
	cd cocoapi/PythonAPI
	make install
	cd ${PROJECT_ROOT}
fi

$(GIT_FETCH "cocoapi")

mkdir -p /media/pjh3974/datasets
if [[ -z "detectron2/$COCO_PATH" ]]; then
	ln -s "$MOUNT_PATH/$COCO_PATH" detectron2/$COCO_PATH 
fi

if [[ -z "AdelaiDet/$COCO_PATH" ]]; then
	ln -s "$MOUNT_PATH/$COCO_PATH" AdelaiDet/$COCO_PATH 
fi
