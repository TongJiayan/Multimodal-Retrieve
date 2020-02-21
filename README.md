# Multimodal-Retrieve

Evaluate the performance of multimodal retrieval algorithms with **mAP** on some datasets.

## Algorithms

1. CCA
2. PLS

## Datasets

PASCAL VOC 2007. This experiment uses the formative dataset provided by [1].

## Train

Train with **2808** samples with only one object. The feature used are **GIST(visual feature)** and **word-frequency(tag feature)** which were explained in [1]. 

## Test and Evaluate

Evaluate the model with **2841** test samples with only one object. 

Retrieve related images with word frequency from train datasets. Return an ordered list, in which an element indicates the index of retrieved image in train datasets.

In evaluate part, if the object in prediction image is same with the ground_truth, set it as true.

The computing method of mAP following the steps when it used in recommended system research area. Take [2] as reference.

## References

*[1]*. Accounting for the Relative Importance of Objects in Image Retrieval, S.J.Hwang, BMVC 2010
*[2]*. https://zhuanlan.zhihu.com/p/74429856 

##  Result

#### Text-to-Image :
CCA: mAP = 0.1226
PLS: mAP = 0.1854
