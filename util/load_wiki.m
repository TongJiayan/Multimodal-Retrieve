function [data] = load_wiki(config)
    rootPath = config.general.rootPath;
    
    dataPath = strcat(rootPath,'data\wiki\raw_features.mat');
    trainsetCatListPath = strcat(rootPath,'data\wiki\trainset_txt_img_cat.list');
    testsetCatListPath = strcat(rootPath,'data\wiki\testset_txt_img_cat.list');
        
    trainCatList = importdata(trainsetCatListPath);
    testCatList = importdata(testsetCatListPath);

    data = {};
    data.train = {};
    data.test = {};
    load(dataPath);
    data.train.image = pre_process(I_tr);
    data.train.text = pre_process(T_tr);
    data.train.cat_list = trainCatList.data;
    data.test.image = pre_process(I_te);
    data.test.text = pre_process(T_te);
    data.test.cat_list = testCatList.data;
end

function[processed_data] = pre_process(raw_data)
    dataSize = size(raw_data,1);
    % Decentralization
    processed_data = raw_data - repmat(mean(raw_data),dataSize,1);
    % Normalize
    processed_data = processed_data * sqrt(diag(1./diag(processed_data'*processed_data)));
    processed_data(isnan(processed_data)==1)=0;
end