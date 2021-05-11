---
- name: test loop with
  hosts: slave
  remote_user: root
  tasks:
  - name: add several users
    debug: msg="Hi,{{ item.name }},how are you {{ item.groups }}"
    with_items:
    - {name: one, groups: root}
    - {name: two, groups: nginx}
