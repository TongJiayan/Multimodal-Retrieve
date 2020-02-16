% INITIALIZE
% root_path = 'E:\毕业设计\多模态数据匹配\实验\CCA\Experiment On Pascal 2007\Multimodal-Retrieve-CCA';
root_path = '~/Multimodal-Retrieve-CCA';
cd(root_path)
config = initialize();
clear root_path;
%%
% LOAD TRAIN DATA
[D, taglist] = load_data(config, 'train');
disp('training dataset are all loaded.');
%%
% EXTRACT FEATURES
F = extract_features(D, taglist, config,'train');
disp('tag and visual features have been extracted.');

% TRAIN COEFFICIENT MATRIX
[A,B,r,U,V] = canoncorr(F.gist,F.wc);
disp('coefficient matrix has been trained.');
%%
% [TEST]: LOAD TEST DATA
[TD, test_taglist] = load_data(config,'test');
disp('test dataset are all loaded.');
%%
% [TEST]: EXTRACT FEATURES
TF = extract_features(TD, test_taglist,config,'test');
disp('test dataset tag and visual features have been extracted.');
%%
% RETRIEVE 
result_list = retrieve('tag-image',TF,A,B,config);
disp('Relative images have been retrieved according to tag feature.');
%%
% EVALUATE
theNumberOfEachObject = load_objectcount(TD,config);

[mAP1,mAP2] = evaluate(TD, result_list,theNumberOfEachObject, config);
disp("With trapz function:mAP=");
disp(mAP1);
disp("Compute AP directly, mAP=");
disp(mAP2);