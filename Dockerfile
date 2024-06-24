FROM nvidia/cuda:11.7.1-devel-ubuntu22.04

WORKDIR /app

RUN apt update \
        && apt -y install python3.10 python3-pip python3.10-venv libglu1-mesa-dev libglib2.0-0 git netcat curl wget vim unzip cmake build-essential \
        && ln -s /usr/bin/python3 /usr/local/bin/python \
        && apt-get clean autoclean \
        && apt-get autoremove --yes \
        && rm -rf /var/lib/{apt,dpkg,cache,log} \
        && pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

# 复制 comfyui 本体 + 插件的依赖文件
COPY requirements.txt .
# 只添加需要的插件的依赖，防止过度添加导致冲突
COPY custom_nodes/ComfyUI-Advanced-ControlNet/requirements.txt custom_nodes/ComfyUI-Advanced-ControlNet/requirements.txt
COPY custom_nodes/comfyui-animatediff/requirements.txt custom_nodes/comfyui-animatediff/requirements.txt
COPY custom_nodes/ComfyUI_FaceAnalysis/requirements.txt custom_nodes/ComfyUI_FaceAnalysis/requirements.txt
COPY custom_nodes/ComfyUI_InstantID/requirements.txt custom_nodes/ComfyUI_InstantID/requirements.txt

# 安装依赖
RUN pip3 install -r requirements.txt \
    && for req in custom_nodes/*/requirements.txt; do pip3 install -r &req; done