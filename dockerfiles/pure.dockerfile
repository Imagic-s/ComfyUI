# 纯净的 comfyUI 镜像
FROM nvidia/cuda:11.7.1-devel-ubuntu22.04

WORKDIR /app

RUN apt update \
        && apt -y install python3.10 python3-pip python3.10-venv libglu1-mesa-dev libglib2.0-0 git netcat curl wget vim unzip cmake build-essential \
        && ln -s /usr/bin/python3 /usr/local/bin/python \
        && apt-get clean autoclean \
        && apt-get autoremove --yes \
        && rm -rf /var/lib/{apt,dpkg,cache,log} \
        && pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple


RUN git clone https://github.com/comfyanonymous/ComfyUI.git

WORKDIR /app/ComfyUI

RUN pip install --no-cache-dir -r requirements.txt
