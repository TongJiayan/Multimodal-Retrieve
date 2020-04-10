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

### Raw Features

#### Experiment on PASCAL（GIST、Word Frequency）:

|           | Image-to-text(mAP) | Text-to-image(mAP) |
| :-------: | :----------------: | :----------------: |
|    CCA    |       0.1962       |       0.1754       |
|    PLS    |       0.2266       |       0.1879       |
|    BLM    |       0.2419       |       0.2085       |
|   GMMFA   |       0.2424       |       0.2089       |
|  CCA+PCA  |       0.2252       |       0.1958       |
|  PLS+PCA  |       0.2450       |       0.2015       |
|  BLM+PCA  |       0.2450       |       0.2045       |
| GMMFA+PCA |       0.2465       |       0.2050       |
|           |                    |                    |

### Experiment on Wiki（SIFT、LDA）:

|           | Image-to-text(mAP) | Text-to-image(mAP) |
| :-------: | :----------------: | :----------------: |
|    CCA    |       0.2435       |       0.1978       |
|    PLS    |       0.2075       |       0.1654       |
|    BLM    |       0.2589       |       0.2008       |
|   GMMFA   |       0.2481       |       0.1997       |
|  CCA+PCA  |       0.2649       |       0.2162       |
|  PLS+PCA  |       0.2477       |       0.2047       |
|  BLM+PCA  |       0.2607       |       0.2101       |
| GMMFA+PCA |       0.2471       |       0.2006       |



### Deep Features

#### Experiment on PASCAL(VGG19、Word Frequency)

|       | Image-to-text(mAP) | Text-to-image(mAP) |
| :---: | :----------------: | :----------------: |
|  CCA  |       0.3552       |       0.3382       |
|  PLS  |       0.6611       |       0.6986       |
|  BLM  |       0.6355       |       0.6381       |
| GMMFA |       0.6374       |       0.6403       |

#### Experiment on WIKIPEDIA(VGG19、LDA)

|       | Image-to-text(mAP) | Text-to-image(mAP) |
| :---: | :----------------: | :----------------: |
|  CCA  |       0.3126       |       0.2814       |
|  PLS  |       0.3879       |       0.3505       |
|  BLM  |       0.3840       |       0.3650       |
| GMMFA |       0.3950       |       0.3570       |

