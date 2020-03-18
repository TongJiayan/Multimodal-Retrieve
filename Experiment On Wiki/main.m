% INITIALIZE
% root_path = 'E:\毕业设计\多模态数据匹配\实验\Experiment On Wiki\Multimodal-Retrieve-On-Wiki\';
root_path = '~/Multimodal-Retrieve/Multimodal-Retrieve-On-Wiki/';
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
elseif strcmp('BLM',config.general.algorithm)
    dataCell = cell(2,1);
    dataCell{1,1}.label = (1:1:config.train.dataSize).';
    dataCell{1,1}.data = data.train.text;
    dataCell{2,1}.label = (1:1:config.train.dataSize).';
    dataCell{2,1}.data = data.train.image; 
    
    options.method = 'BLM';
    options.Factor= 20;
    options.Lamda = 900;
  
    Wout = Newgma(dataCell,options);
    result_list = retrieve_BLM('image-to-text', data.test, Wout);
elseif strcmp('GMMFA',config.general.algorithm)
    dataCell = cell(2,1);
    dataCell{1,1}.label = (1:1:config.train.dataSize).';
    dataCell{1,1}.data = data.train.text;
    dataCell{2,1}.label = (1:1:config.train.dataSize).';
    dataCell{2,1}.data = data.train.image; 
    
    options.method = 'MFA';
    options.Factor= 20;
    options.Lamda = 10;
    options.Mult = [1 1];
    options.ReguAlpha = 1e-6;
  
    Wout = Newgma(dataCell,options);
    result_list = retrieve_GMMFA('image-to-text', data.test, Wout);
end

% EVALUATE
[mAP] = evaluate(result_list,catList,config);
output = sprintf('The performance of %s (mAP)= %.4f',config.general.algorithm,mAP);
disp(output);
