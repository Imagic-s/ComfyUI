import json

"""
通过 api workflow 获取所有插件列表
"""

def check_json_syntax(file_path):
    try:
        with open(file_path, 'r') as file:
            json_str = file.read()
            json.loads(json_str)
            return True
    except:
        return False


workflow_filepath = './3inputs_2people_api.json'


def main():
    # 获取工作流(workflow-api.json)里 所有的 class_type，去重
    class_type_set = set()
    with open(workflow_filepath, 'r') as file:
        json_str = file.read()
        j = json.loads(json_str)
    for _, value in j.items():
        class_type = value.get('class_type')
        class_type_set.add(class_type)
    print(f'length of class_type_set: {len(class_type_set)}')
    # print(' '.join(class_type_set))

    # 通过 class_type 获取所有的 github 依赖，同个 class_type 可能会有多个依赖
    title2url = {}
    with open('./extension-node-map.json', 'r') as file:
        json_str = file.read()
        j = json.loads(json_str)
    for url, (elems, _) in j.items():
        for elem in elems:
            if elem not in title2url:
                title2url[elem] = []
            title2url[elem].append(url)
    requires = {}
    for class_type in class_type_set:
        # 忽略掉含有 'https://github.com/comfyanonymous/ComfyUI' 的记录
        if 'https://github.com/comfyanonymous/ComfyUI' in title2url[class_type]:
            continue
        requires[class_type] = title2url[class_type]
    print(f'length of requires: {len(requires)}')
    # print(requires)

    # 去重
    require_set = set()
    for _, require_list in requires.items():
        for require in require_list:
            require_set.add(require)
    print(require_set)
    print()

    # 去掉没有依赖的插件

    # git协议
    require_set_git = set()
    for r in require_set:
        require_set_git.add(r.replace('https://github.com/', 'git@github.com:'))
    print(require_set_git)


if __name__ == '__main__':
    main()
