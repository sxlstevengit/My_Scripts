---
- hosts: C
  remote_user: root
  vars:
   Va1: "hello world"
   Va2: "Hello nimei"
   nginx:
    conf80: /tmp/80.conf
    conf88: /tmp/88.conf
  tasks:
  - name: show messages
    debug: print {{ Va1 }}
  - name: create file and write
    shell: 
      echo {{ Va2 }} >>/tmp/haha.txt
  - name: create nginx conf80
    file:
     path: "{{ nginx.conf80 }}"
     state: touch
    tags: ng
  - name: create nginx conf88
    file: path={{ nginx.conf88 }} state=touch 
    tags: ng
