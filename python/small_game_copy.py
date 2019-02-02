import random

# version 3
# l1 = ["0","1","2"]
# while True:
#     people = input("Please input (0石头、1剪刀、2布):")
#     computer = random.randint(0,2)
#     if people not in l1:
#         print("输入错误，请按规定输入!!!")
#         continue
#     else:
#         people = int(people)
#
#     if ( people == 0 and computer == 1 ) or ( people == 1 and computer == 2 ) or ( people == 2 and computer == 0 ):
#         print("你牛B哄哄啊，怎么总是赢,不开心，再来")
#     elif people == computer:
#         print("我们心有灵犀一点通，哈哈")
#     else:
#         print("你输了，先给钱啊！！再来")

# # version4
# options = ["是","否"]
# default = ["石头","剪刀","布"]
# begin = input("亲爱的，我们来玩一个游戏，你输了，给我买包包!! 赢了，想怎么样就怎么样。你选择接受还是拒绝\n 请输入【是和否】: ")
# mywords = "成本太高，不玩"
# if begin not in options or begin == options[1]:
#     print(mywords)
# elif begin == options[0]:
#     rule = [["石头", "剪刀"], ["剪刀", "布"], ["布", "石头"]]
#     while True:
#         computer = random.choice(default)
#         people = input("请输入石头、剪刀、布:")
#         if people not in default:
#             print ("赖皮，滚")
#             continue
#         elif [computer,people] in rule:
#             print ("我赢了，我的地盘我做主,超开心")
#         else:
#             print("不开心，怎么总是我输")

# create password
# import string
#
# password = ""
# # for i in range(6):
# #     if random.randint(0,1):
# #         password += string.ascii_letters[random.randint(0,51)]
# #         # print(password)
# #     else:
# #         password += string.digits[random.randint(0,9)]
# #         print(password)
# # print(password)
#
# letters = list(string.ascii_letters)
# num = list(string.digits)
# for i in range(8):
#     password += random.choice( letters + num )
# print(password)


l1 = ["0","1","2"]
while True:
    people = input("Please input (0石头、1剪刀、2布):")
    computer = random.randint(0,2)
    try:
        people = int( people )
    except:
        print( "输入错误，请按规定输入!!!" )
        continue
    else:
        print("hello world")
    # if ( people == 0 and computer == 1 ) or ( people == 1 and computer == 2 ) or ( people == 2 and computer == 0 ):
    #     print("你牛B哄哄啊，怎么总是赢,不开心，再来")
    # elif people == computer:
    #     print("我们心有灵犀一点通，哈哈")
    # else:
    #     print("你输了，先给钱啊！！再来")

