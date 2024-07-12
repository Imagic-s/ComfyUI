FROM comfypure:latest as base

WORKDIR /app/ComfyUI/custom_nodes/

# git clone 需要的插件
ARG NODE_REPOS

RUN for repo in $(echo $NODE_REPOS | tr "," "\n"); do \
        git clone $repo; \
        done

# 安装这些插件的依赖
RUN for req in ./*/requirements.txt; do \
        pip install --no-cache-dir -r $req; \
        done

WORKDIR /app/ComfyUI

ENTRYPOINT ["python3", "main.py"]

CMD ["--listen", "127.0.0.1", "--port", "18189"]
