# 一. 环境安装
```bash
# 安装python的虚拟环境和pip包管理工具
sudo apt update
sudo apt install python3-pip python3-venv -y

# 创建虚拟环境
python3 -m venv /home/apluser/ansible-env/
# 激活虚拟环境
source /home/apluser/ansible-env/bin/activate
# 退出虚拟环境
deactivate

# 在虚拟环境中安装Ansible
pip install ansible

# 验证
ansible --version
```

# 二. Role相关
🔷role的作用
把 Playbook 按照功能`模块化`，方便复用、维护和团队协作。

🔷生成role
```bash
ansible-galaxy init nginx
```

🔷官方推荐的role目录
```bash
roles/
└── nginx/
    ├── defaults/
    │   └── main.yml
    │
    ├── files/
    │
    ├── handlers/
    │   └── main.yml
    │
    ├── meta/
    │   └── main.yml
    │
    ├── tasks/
    │   └── main.yml
    │   └── sub-task1.yml
    │   └── sub-task2.yml
    │
    ├── templates/
    │
    ├── vars/
    │   └── main.yml
    │
    └── README.md
```

# 三. ansible.cfg
🔷ansible.cfg优先级又由高到低如下所示:
1. ANSIBLE_CONFIG → 环境变量
2. ./ansible.cfg → 当前目录
3. ~/.ansible.cfg → 用户家目录
4. /etc/ansible/ansible.cfg

# 四. 命令行
🔷使用ansible
```bash
# 查看所有主机的hostname, 因为 ansible.cfg 文件中指定了hosts.ini配置文件, 所以没有在命令行中指定
ansible all -m shell -a "hostname"

ansible ubuntu -i ./inventory/hosts.ini -m command -a "whoami"
ansible ubuntu -i ./inventory/hosts.ini -m shell -a "hostname && df -h"
# 可以临时修改端口号, 只适用于 hosts.ini 中没有写出端口号的情况
ansible ubuntu -i ./inventory/hosts.ini -m shell -a "df -h && hostname" --ssh-extra-args="-p 22"
```

🔷配置查看
```bash
# 查看 hosts.ini 的详细信息
ansible-inventory -i ./inventory/hosts.ini --list

# 以结构化的方式显示出受管主机的信息
ansible-inventory --graph

# 查看默认的配置项
ansible-config dump
# 查看被修改的配置项
ansible-config dump --only-changed
```

🔷使用playbook
```bash
# 因为要安装软件, 所以必须要使用root用户或者普通用户sodo提权
# 指定要运行的环境, 通过 --ask-become-pass 配置项在命令行提示用户输入sudo提权密码(注意不是root用户的密码)
# target_host对应的值应该来源于 ./inventory/hosts.ini 中的组
ansible-playbook -i ./inventory/hosts.ini ./playbooks/install-nginx.yml -e target_host=ubuntu --ask-become-pass
ansible-playbook -i ./inventory/hosts.ini ./playbooks/uninstall-nginx.yml -e target_host=ubuntu --ask-become-pass

ansible-playbook -i ./inventory/hosts.ini ./playbooks/02_disk.yml -e target_host=ubuntu
```

🔷使用role + 环境check
| option           | 作用           
| ---------------- | ------------  
| `-i hosts.ini`   | 指定 Inventory
| `-l web`         | 只执行 web 组  
| `--check`        | 模拟执行       
| `--diff`         | 查看变更内容   
| `-v`             | 详细输出       
| `-vvv`           | 调试模式       
| `--syntax-check` | 检查 YAML 语法 

```bash
# -i → --inventory 
#      --inventory-file
# -e → --extra-vars
# --check：模拟执行
# --diff：查看变更内容
ansible-playbook -i ./inventory/d01.ini \
                -e exec_env=d01 \
                -e sudo_pass=apluser \
                -e target_host=site_d01 site.yml \
                --check --diff
```

# 五. 配置项
## 5.1 gather_facts
🔷gather_facts 是 Ansible Playbook 中的一个重要选项，它决定了 在执行 tasks 之前，是否先收集目标主机的信息(Facts)。
Facts它会收集大量信息，例如：
+ 操作系统
+ 主机名
+ IP 地址
+ CPU
+ 内存
+ 磁盘
+ Python 信息
+ 网络接口
+ 时间
+ 环境变量
+ BIOS 信息
+ Virtual Machine 信息

🔷当需要使用这些变量的时候, 需要收集Facts
```bash
ansible_hostname
ansible_date_time
ansible_default_ipv4
ansible_distribution
ansible_distribution_major_version
ansible_os_family
ansible_processor
ansible_memory_mb
ansible_mounts
ansible_interfaces
ansible_architecture
ansible_env
```

🔷如果 Playbook 只是执行**简单操作**(如 ping、copy、service、shell 等)，建议设置 `gather_facts: false`，可以减少不必要的开销。
  如果 Playbook 需要根据目标主机的操作系统、网络、硬件等信息做判断或使用 `ansible_*` Facts 变量，则保留默认的 `gather_facts: true`
  或者在需要的时候显式调用 `ansible.builtin.setup` 收集 Facts

```bash
# 查看所有的 Facts
ansible all -m setup
# 查看指定的 Facts
ansible all -m setup -a "filter=ansible_hostname"
```

# 九. 其他
🔷inventory文件夹下的 host_vars 和 group_vars 文件夹
1. 文件的名称要和组名 或者 host 地址相同
2. 如果同一个变量同时出现在 host_vars 和 group_vars 中, host_vars 的值会覆盖 group_vars 的值

