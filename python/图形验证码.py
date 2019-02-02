from PIL import Image,ImageDraw,ImageFont,ImageFilter
import random

def ranChar():
    return chr(random.randint(65,90))

def ranColor():
    return(random.randint(64,255),random.randint(64,255),random.randint(64,255))

def rndColor2():
    return (random.randint(32, 127), random.randint(32, 127), random.randint(32, 127))

width = 60 * 4
height = 60

image = Image.new('RGB',(width,height),(255, 255, 255))
font = ImageFont.truetype('C:\Windows\Fonts\Arial.ttf',36)

draw = ImageDraw.Draw(image)
for x in range(width):
    for y in range(height):
        draw.point((x,y),fill=ranColor())

for t in range(4):
    draw.text((60 * t + 10,10),ranChar(),font=font,fill=rndColor2())


# image = image.filter(ImageFilter.BLUR)
image.save('code.jpg','jpeg')