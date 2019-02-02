import random

# version1
# 感觉这个小程序还可以写的更好，但是有bug，如果输入字符串直接就报错。
# while True:
#     people = int(input( "[0:石头 1:剪刀 2:布],Please choice what you want:" ))
#     computer = random.randint(0,2)
#     if (people not in (0,1,2)):
#         print("Input error,Please input again")
#         continue
#     if (people == 0 and computer == 1) or (people == 1 and computer == 2) or (people == 2 and computer == 0):
#         print("You are a genius boy，you win")
#     elif people == computer:
#         print ("just so so,please try again")
#     else:
#         print("you are loser")

# version2

option = ["是","否"]
play = input("我们来玩个游戏吧，如果你输了，会有惩罚。\n 请选择是或否:")
myword = "交女朋友成本太高了，算了我们分手吧"

if play not in option or play == option[1]:
    print(myword)
elif play == option[0]:
    default = ["石头","剪刀","布"]
    rule = [["石头","剪刀"],["剪刀","布"],["布","石头"]]
    while True:
        computer = random.choice(default)
        people = input("Please input {石头、剪刀、布}:")
        if people not in default:
            print("你耍赖，我不要做你女朋友了!!")
            break
        if people == computer:
            print("我们心有灵犀一点通，haha")
        elif [people,computer]  in rule:
            print ("你怎么这么不懂事，不让着我。")
        else:
            print("好高兴")





