if [ ! -d "$DIRECTORY" ]; then
    mkdir ./save
fi

export CUDA_VISIBLE_DEVICES=0

model=mobilenetv1
epochs=1
batch_size=64
lr=1e-3
loss=mse
weight_decay=4e-5
dataset="imagenet"
log_file="training.log"

wbit=8
abit=8
xqtype="qdrop"
wqtype="minmax_channel"
num_samples=1024
ttype=ptq
layer_train=True

pre_trained="/home/jm2787/MLSys24/T2C/save/imagenet/mobilenetv1/mobilenetv1_w_a_lr0.1_batch256_loss/checkpoint.pth.tar"
save_path="./save/${dataset}/${model}/${ttype}/${xqtype}_${wqtype}/${model}_w${wbit}_a${abit}_lr${lr}_batch${batch_size}_${loss}loss_layer_train${layer_train}/"

python3 -W ignore ./imagenet/ptq.py \
    --save_path ${save_path} \
    --model ${model} \
    --epochs ${epochs} \
    --log_file ${log_file} \
    --lr ${lr} \
    --weight-decay ${weight_decay} \
    --batch_size ${batch_size} \
    --loss_type ${loss} \
    --dataset ${dataset} \
    --mixed_prec True \
    --optimizer adam \
    --trainer ${ttype} \
    --wqtype ${wqtype} \
    --xqtype ${xqtype} \
    --wbit ${wbit} \
    --abit ${abit} \
    --num_samples ${num_samples} \
    --fine_tune \
    --resume ${pre_trained} \
    --train_dir "/share/seo/imagenet/train/" \
    --val_dir "/share/seo/imagenet/val/" \
    --layer_trainer ${layer_train} \