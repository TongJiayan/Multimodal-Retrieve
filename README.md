# Multimodal-Retrieve-CCA

Evaluate the performance of **CCA** for multimodal retrieve tasks with **mAP**.

## Dataset

The dataset used is *PASCAL VOC 2007*. This experiment uses the formative dataset provided by [1].

## Algorithm

Canonical Correlation Analysis. For understanding the principles, the documents under *Documents* folder help me a lot.

## Train

Train with **5011** samples. The feature used are **GIST(visual feature)** and **word-count(tag feature)** which were explained in [1]. 

## Test and Evaluate

Evaluate the model with **100** samples. Retrieve related images with some tags and return an ordered list, in which an element indicates the index of retrieved image.
For the moment, the method to judge whether a precondition is right is showed following:

1. Compute the intersection of two arrays(don't ignore repeat ones): retrieval taglist(A), the taglist of retrieved image(B)

2. Compute the reward function simply as 
   $$
   s = \frac{|A \cap B|}{|A|}
   $$

3. Set threshold value, when reward is greater than threshold value, I set it as true.

4. The computing method of mAP following the steps when it used in recommended system research area. Take https://zhuanlan.zhihu.com/p/74429856 as reference.

## References

*[1]*. Accounting for the Relative Importance of Objects in Image Retrieval, S.J.Hwang, BMVC 2010

##  Update Plan

1. Optimize the reward function with taking object-count and scale into account.
2. Optimize the method to compute mAP. 
