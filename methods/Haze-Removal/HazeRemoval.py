#!/usr/bin/env python
# encoding: utf-8

from PIL import Image
import numpy as np

def haze_removal(image, windowSize=24, w0=0.6, t0=0.1):

    darkImage = image.min(axis=2)
    maxDarkChannel = darkImage.max()
    darkImage = darkImage.astype(np.double)

    t = 1 - w0 * (darkImage / maxDarkChannel)
    T = t * 255
    T.dtype = 'uint8'

    t[t < t0] = t0

    J = image
    J[:, :, 0] = (image[:, :, 0] - (1 - t) * maxDarkChannel) / t
    J[:, :, 1] = (image[:, :, 1] - (1 - t) * maxDarkChannel) / t
    J[:, :, 2] = (image[:, :, 2] - (1 - t) * maxDarkChannel) / t
    result = Image.fromarray(J)

    return result

if __name__ == '__main__':
    imageName = "canon3.bmp"
    image = np.array(Image.open('images/' + imageName))
    imageSize = image.shape
    result = haze_removal(image)
    result.show()
