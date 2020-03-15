function [data,catList] = load_data(config)
    rootPath = config.general.rootPath;
    % trainDataSize = config.train.dataSize;
    % testDataSize = config.test.dataSize;
    
    dataPath = strcat(rootPath,'data\raw_features.mat');
    trainsetCatListPath = strcat(rootPath,'data\trainset_txt_img_cat.list');
    testsetCatListPath = strcat(rootPath,'data\testset_txt_img_cat.list');
    
    data = {};
    data.train = {};
    data.test = {};
    load(dataPath);
    data.train.image = I_tr;
    data.train.text = T_tr;
    data.test.image = I_te;
    data.test.text = T_te;
    
    catList = {};
    trainCatList = importdata(trainsetCatListPath);
    catList.train = trainCatList.data;
    testCatList = importdata(testsetCatListPath);
    catList.test = testCatList.data;
    
end

