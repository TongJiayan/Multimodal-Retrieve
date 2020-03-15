# Multimodal-Retrieve

Evaluate the performance of multimodal retrieval algorithms with **mAP** on some datasets.

## Algorithms

1. CCA
2. PLS
3. BLM
4. GMMFA

## Datasets

PASCAL VOC 2007. This experiment uses the formative dataset provided by [1].

Wikipedia. http://www.svcl.ucsd.edu/projects/crossmodal/

## Train

### PASCAL

Train with **2808** samples with only one object. The feature used are **GIST(visual feature)** and **word-frequency(tag feature)** which were explained in [1]. 

### Wiki

Train with **2173** samples. The images were represented by 128-dimensional vector quantized features with SIFT and the text feature is derived from the latent Dirichlet allocation model with 10 dimensions.

## Test and Evaluate

For PASCAL datasets, I evaluate the model with **2841** test samples with only one object. 

For Wiki datasets, I evaluate the model with **693** test samples.

**Image-to-text :** Retrieve related images with text from testset. Return an ordered list, in which each element indicates the index of retrieved image in testset**.**

**Text-to-image :** Retrieve related text with image from testset. Return an ordered list, in which each element indicates the index of retrieved text in testset**.**

In evaluate part, if the object/class in prediction image is same with the ground_truth, set it as true.

The computing method of mAP following the steps when it used in recommended system research area. Take [2] as reference.

## References

*[1]*. Accounting for the Relative Importance of Objects in Image Retrieval, S.J.Hwang, BMVC 2010
*[2]*. https://zhuanlan.zhihu.com/p/74429856 

##  Result

#### Experiment on PASCAL:
|       | Image-to-text(mAP) | Text-to-image(mAP) |
| :---: | :----------------: | :----------------: |
|  CCA  |       0.1335       |       0.1226       |
|  PLS  |       0.2265       |       0.1900       |
|  BLM  |       0.2420       |       0.2085       |
| GMMFA |       0.2419       |       0.2085       |

### Experiment on Wiki:

|       | Image-to-text(mAP) | Text-to-image(mAP) |
| :---: | :----------------: | :----------------: |
|  CCA  |       0.1867       |       0.1322       |
|  PLS  |       0.2479       |       0.1428       |
|  BLM  |                    |                    |
| GMMFA |                    |                    |

