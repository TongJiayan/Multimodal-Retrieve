
% INITIALIZE
% root_path = 'E:\毕业设计\多模态数据匹配\实验\Experiment On Pascal 2007\Multimodal-Retrieve-On-Pascal\';
root_path = '~/Multimodal-Retrieve';
cd(root_path)
config = initialize();
clear root_path;
%%
% LOAD TRAIN DATA
dataset = config.general.dataset;
if strcmp(dataset,'PASCAL')
    data = load_pascal(config); 
elseif strcmp(dataset,'WIKI')
    data = load_wiki(config);
end
%%
% TRAIN MODEL and TEST
dataCell = cell(2,1);
dataCell{1,1}.label = (1:1:config.trainDataSize).';
dataCell{2,1}.label = (1:1:config.trainDataSize).';
dataCell{1,1}.data = data.train.text;
dataCell{2,1}.data = data.train.image;
%%
[factor, lamda] = set_parameters(config);

if config.general.pca == 1
    options.PCA = config.general.pca;
end
options.Factor = factor;
options.Lamda = lamda;

if strcmp('CCA',config.general.algorithm)   
%    [A,B,r,U,V] = canoncorr(F.gist,F.wc);
%    result_list = retrieve_CCA('image-tag',TF,A,B);
%    disp('Relative images have been retrieved according to tag feature.');  
    options.method='CCA';
    options.ReguAlpha =0.01;   
elseif strcmp('PLS',config.general.algorithm)   
%     [XL,YL,XS,YS,BETA,PCTVAR,MSE] = plsregress(F.wc,F.gist,16);
%     result_list = retrieve_PLS('image-tag',TF,BETA);
%     disp('Relative images have been retrieved according to tag feature.');

    options.method='PLS';
    options.ReguAlpha =0.01;
    
    % ncomp = find(cumsum(PCTVAR(2,:)) >= pve,1, 'first');
    % plot(1:350,cumsum(100*PCTVAR(2,:)));
    % plot(1:350,100*PCTVAR(2,:));
    % xlabel('Number of PLS components');
    % ylabel('Percent Variance Explained in y');  
elseif strcmp('BLM',config.general.algorithm) 
    options.method = 'BLM';
    options.Factor = factor;
    options.Lamda = lamda;
elseif strcmp('GMMFA',config.general.algorithm)  
    options.method = 'MFA';
    options.ReguAlpha = 1e-6;
    options.Mult = [1 1];
end

Wout = Newgma(dataCell,options);

result_list = retrieve(config.general.direction, data.test, Wout , config.general.pca);

% EVALUATE
[mAP] = evaluate(data.test, result_list, config);
output = sprintf('The performance of %s (mAP) on dataset %s (%s)= %.4f',config.general.algorithm,config.general.dataset,config.general.direction,mAP);
disp(output);