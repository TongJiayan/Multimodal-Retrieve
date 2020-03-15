% INITIALIZE
% root_path = 'E:\毕业设计\多模态数据匹配\实验\Experiment On Wiki\Multimodal-Retrieve-On-Wiki\';
root_path = '~/Multimodal-Retrieve/Experiment On Wiki/';
cd(root_path)
config = initialize();
clear root_path;
%%
% LOAD DATA
[data,catList] = load_data(config);
%%
% TRAIN MODEL and TEST
if strcmp('CCA',config.general.algorithm)
    [A,B,r,U,V] = canoncorr(data.train.image,data.train.text);
    result_list = retrieve_CCA('image-to-text',data.test,A,B);
    disp('Relative images have been retrieved according to tag feature.');
elseif strcmp('PLS',config.general.algorithm)
    [XL,YL,XS,YS,BETA,PCTVAR,MSE] = plsregress(data.train.text,data.train.image,5);
    result_list = retrieve_PLS('text-to-image',data.test,BETA);
    disp('Relative images have been retrieved according to tag feature.');
end

% EVALUATE
[mAP] = evaluate(result_list,catList,config);
output = sprintf('The performance of %s (mAP)= %.4f',config.general.algorithm,mAP);
disp(output);
