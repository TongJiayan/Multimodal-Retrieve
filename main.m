%% 
% INITIALIZE
%%% Modify root_path to your path
root_path = '~/Multimodal-Retrieve-CCA';
cd(root_path)
config = initialize();
clear root_path;


% LOAD TRAIN DATA
[D, taglist] = load_data(config, 'train');
disp('training dataset are all loaded.');

%%

%%
% EXTRACT FEATURES
F = extract_features(D, taglist, config,'train');
disp('tag and visual features have been extracted.');

% TRAIN COEFFICIENT MATRIX
%%%%
%%% We should set both the visual features and tag features are
%%% corresponding with variables in retrieve.m file
%%%%
[A,B,r,U,V] = canoncorr(F.bow,F.abs);
%%

%%
% [TEST]: LOAD TEST DATA
[TD, test_taglist] = load_data(config,'test');
disp('test dataset are all loaded.');

% [TEST]: EXTRACT FEATURES
TF = extract_features(TD, test_taglist,config,'test');
disp('test dataset tag and visual features have been extracted.');

%%
result_list = retrieve('tag-image',TF,A,B,config);

% EVALUATE mAP
threshold_value = 0.7;
[mAP, scores] = evaluate(TD, result_list,threshold_value, config);
disp("CCA Algorithm applied on PASCAL VOC 2007 dataset : mAP = ");
disp(mAP);
