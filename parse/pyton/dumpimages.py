#!python
from urllib2 import urlopen
from urllib import urlretrieve
from PIL import Image, ImageOps, ImageEnhance
import os
import sys
import re
import time

def main(url, n):
    print "OK1"
    # get url session url

    imgurl = "http://rusfolder.com/random/images/\?session=55"
    print "OK5"



    # gen imgs

    for i in range(n):
        urlretrieve(imgurl, 'C:/razr/apache/cgi-bin/parse/pyton/test/' + str(i) + '.gif')
        time.sleep(1)
        print str(i) + ' of ' + str(n) + ' downloaded'

    # convert them
    for i in range(n):
        img = Image.open('/test/' + str(i) + '.gif').convert('L')
        img = ImageOps.invert(img)
        img = ImageEnhance.Contrast(img).enhance(1.9)
        img.save('/test/' + str(i) + '.bmp')
        #os.unlink('/test/' + str(i) + '.gif')


if __name__ == "__main__":
 #   url = sys.argv[-1]
    url = "http://rusfolder.com/?num"
    print "OK2"
    if not url.lower().startswith("http"):
        print "OK3"
        print "usage: python dumpimages.py http://ifolder.com/?num"
        sys.exit(-1)
        print "OK4"
    main(url, 500)
#main("http://rusfolder.com/?num", 500)
