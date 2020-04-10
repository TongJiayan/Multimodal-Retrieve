
dataPath = 'E:\毕业设计\多模态数据匹配\实验\Experiment On Pascal 2007\Multimodal-Retrieve-On-Pascal\data\pascal\test.mat';
load(dataPath);
D = [D1 D2];
raw_data = [];

one_object_list = [];
% Filter samples which has only one object
for n = 1:size(D,2)
    if(length(find(D(n).objectcount == 0))==19)
        one_object_list = [one_object_list; D(n).filename];
    end
end  


%%
image_path = 'E:\毕业设计\多模态数据匹配\实验\Experiment On Pascal 2007\Dataset\VOCtest_06-Nov-2007\VOCdevkit\VOC2007\JPEGImages\';
targetPath = 'E:\毕业设计\多模态数据匹配\实验\Experiment On Pascal 2007\Dataset\VOCtest_06-Nov-2007\VOCdevkit\VOC2007\JPEGImages\One_Object\';
% image_path = 'E:\毕业设计\多模态数据匹配\实验\Experiment On Pascal 2007\Dataset\VOCtrainval_06-Nov-2007\VOCdevkit\VOC2007\JPEGImages\';
% targetPath = 'E:\毕业设计\多模态数据匹配\实验\Experiment On Pascal 2007\Dataset\VOCtrainval_06-Nov-2007\VOCdevkit\VOC2007\JPEGImages\One_Object\';
fileList = dir(image_path);
for k = 1 : length(one_object_list)  
    movefile([image_path,one_object_list(k,:)],targetPath);
end 

