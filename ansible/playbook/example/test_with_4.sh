---
- name: test loop with_flattened
  hosts: 192.168.10.74
  remote_user: root
  tasks:
  - debug: msg={{ item }}
  #  with_flattened:
  #  with_items:
    with_list:
    - [1,2,3,4,5]
    - [[a,b]]
    - [[a,],[b,]]
