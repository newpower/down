'''
(C) Indalo
wolfer@vingrad.ru
'''

#import cv2
from cv2 import cv, highgui, adaptors

#from opencv import cv, highgui, adaptors
import sys
import os
from opencv.cv import *
from opencv.highgui import *
from opencv.adaptors import *
from math import sqrt, pow
from PIL import Image, ImageOps, ImageEnhance
from matplotlib import pylab
import matplotlib.pyplot as plt
from pyfann import libfann

bgcolor = 0

def colordist(c1, c2):
	return sqrt(pow(c1 - c2, 2))

def Crop(img, min_left, min_right, min_top, min_bottom):
        top_border = 0
        while (top_border < img.size[1] - 1):
                count = 0
                for i in range(img.size[0]):
                        if colordist(img.getpixel((i, top_border)), bgcolor) > 10:
                                count = count + 1
                if count > min_top:
                        break
                top_border = top_border + 1

        bottom_border = img.size[1] - 1
        while bottom_border > 0:
                count = 0
                for i in range(img.size[0]):
                        if colordist(img.getpixel((i, bottom_border)), bgcolor) > 10:
                                count = count + 1

                if count > min_bottom:
                        break

                bottom_border = bottom_border - 1

        left_border = 0
        while (left_border < img.size[0] - 1):
                count = 0
                for i in range(img.size[1]):
                        if colordist(img.getpixel((left_border, i)), bgcolor) > 10:
                                count = count + 1

                if count > min_left:
                        break

                left_border = left_border + 1

        right_border = img.size[0] - 1
        while right_border > 0:
                count = 0
                for i in range(img.size[1]):
                        if colordist(img.getpixel((right_border, i)), bgcolor) > 10:
                                count = count + 1

                if count > min_right:
                        break

                right_border = right_border - 1

        gray = img.crop((left_border, top_border, right_border, bottom_border))

        return gray

def RemoveLines(img):
    dst = cvCreateImage( cvGetSize(img), IPL_DEPTH_8U, 1 )
    cvCopy(img, dst)
    storage = cvCreateMemStorage(0)
    lines = cvHoughLines2( img, storage, CV_HOUGH_PROBABILISTIC, 1, CV_PI/180, 35, 35, 3 )
    for line in lines:
        cvLine( dst, line[0], line[1], bgcolor, 2, 0 )
    return dst

def FindDividingCols(img):
    lst = []
    for i in range(img.size[0]):
        lst.append(sum(1 for j in range(img.size[1]) if img.getpixel((i, j)) != 0))

    delta = 12
    i = 5
    cols = []
    while len(cols) < 3:
        m = min(lst[i:i + delta])
        j = lst.index(m, i)
        cols.append(j)
        i = j + delta

    '''
    ax1 = pylab.subplot(212)
    pylab.imshow(img.transpose(Image.FLIP_TOP_BOTTOM), cmap=pylab.cm.gray, shape=(img.size[0], img.size[1]), interpolation='bilinear')
    pylab.subplot(211, sharex=ax1)
    pylab.plot(lst)
    print cols
    pylab.show()
    '''

    return cols

def DivideDigits(img):
    cols = FindDividingCols(img)
    imgs = []
    imgs.append(img.crop((0, 0, cols[0], img.size[1])))
    imgs.append(img.crop((cols[0], 0, cols[1], img.size[1])))
    imgs.append(img.crop((cols[1], 0, cols[2], img.size[1])))
    imgs.append(img.crop((cols[2], 0, img.size[0], img.size[1])))

    return imgs

def Sampling(path, n):
    for i in range(n):
        # load image and preprocess it
        src = cvLoadImage(path + str(i) + '.bmp', 0)
        clear = RemoveLines(src)
        pil_image = adaptors.Ipl2PIL(clear)
        img = Crop(pil_image, 3, 3, 3, 3)
        # divide digits on image
        images = DivideDigits(img)
        img.save(path + str(i) + '_.bmp')
        # cut them and save for futher training
        for j in range(len(images)):
            img = Crop(images[j], 1, 1, 2, 2)
            if img.size[0] in range(4, 26) and img.size[1] in range(15, 30):
                img = ImageOps.invert(img)
                img = img.resize((18, 24))
                img.save(path + 'digits/' + str(i) + '_' + str(j) + '.bmp')
        print i

def MagicRegognition(img, ann):
    ann = libfann.neural_net()
    ann.create_from_file('fann.data')

    sample = []
    for i in img.size[1]:
        for j in img.size[0]:
            if colordist(img.getpixel((j, i)), bgcolor) < 10:
                sample[j + i * img.size[0]] = 0
            else:
                sample[j + i * img.size[0]] = 1

    res = ann.run(sample)

    return res.index(max(res))

if __name__ == "__main__":
    Sampling('E:/test/', 500)
