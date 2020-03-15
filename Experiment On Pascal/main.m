% INITIALIZE
root_path = 'E:\毕业设计\多模态数据匹配\实验\Experiment On Pascal 2007\Multimodal-Retrieve-On-Pascal\';
% root_path = '~/Multimodal-Retrieve';
cd(root_path)
config = initialize();
clear root_path;
%%
% LOAD TRAIN DATA
[D, taglist,~] = load_data(config, 'train');
disp('training dataset are all loaded.');

% EXTRACT FEATURES
F = extract_features(D, taglist, config,'train');
disp('tag and visual features have been extracted.');

% LOAD TEST DATA
[TD, test_taglist,theNumberOfEachObject] = load_data(config,'test');
disp('test dataset are all loaded.');

% EXTRACT FEATURES
TF = extract_features(TD, test_taglist,config,'test');
disp('test dataset tag and visual features have been extracted.');
%%
% TRAIN MODEL and TEST
if strcmp('CCA',config.general.algorithm)
    [A,B,r,U,V] = canoncorr(F.gist,F.wc);
    disp('model has been trained.');
    
    result_list = retrieve_CCA('image-tag',TF,A,B);
    disp('Relative images have been retrieved according to tag feature.');
elseif strcmp('PLS',config.general.algorithm)
    [XL,YL,XS,YS,BETA,PCTVAR,MSE] = plsregress(F.wc,F.gist,16);
    disp('model has been trained.');
    % ncomp = find(cumsum(PCTVAR(2,:)) >= pve,1, 'first');
    
    % plot(1:350,cumsum(100*PCTVAR(2,:)));
    % plot(1:350,100*PCTVAR(2,:));
    % xlabel('Number of PLS components');
    % ylabel('Percent Variance Explained in y');
    result_list = retrieve_PLS('image-tag',TF,BETA);
    disp('Relative images have been retrieved according to tag feature.');
elseif strcmp('BLM',config.general.algorithm) 
    dataCell = cell(2,1);
    dataCell{1,1}.label = (1:1:config.train.dataSize).';
    dataCell{1,1}.data = F.wc;
    dataCell{2,1}.label = (1:1:config.train.dataSize).';
    dataCell{2,1}.data = F.gist; 
    
    options.method = 'BLM';
    options.Factor= 61;
    options.Lamda = 500;
  
    Wout = Newgma(dataCell,options);
    result_list = retrieve_BLM('image-tag', TF, Wout);
elseif strcmp('GMMFA',config.general.algorithm)
    dataCell = cell(2,1);
    dataCell{1,1}.label = (1:1:config.train.dataSize).';
    dataCell{1,1}.data = F.wc;
    dataCell{2,1}.label = (1:1:config.train.dataSize).';
    dataCell{2,1}.data = F.gist;
    
    options.method = 'GMMFA';
    options.Factor= 50;
    options.Lamda = 1000;
    options.Mult = [1 1];
    options.ReguAlpha = 1e-6;
    
    Wout = Newgma(dataCell,options);
    result_list = retrieve_BLM('image-tag', TF, Wout);
end

% EVALUATE
[mAP] = evaluate(TD, result_list,theNumberOfEachObject, config);
output = sprintf('The performance of %s (mAP)= %.4f',config.general.algorithm,mAP);
disp(output);