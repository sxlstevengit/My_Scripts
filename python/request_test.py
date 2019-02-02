from PIL import Image,ImageFilter
img = Image.open('mmm.jpg')
w,h = img.size
print("此照片尺寸是:%s x %s" %(w,h))

# img.thumbnail((w//2,h//2))
# print("Resize image size: %s * %s" %(w//2,h//2))
img2 = img.filter(ImageFilter.BLUR)
img2.save("blur.jpg",'jpeg')
